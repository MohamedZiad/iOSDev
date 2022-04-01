//
//  ViewController.swift
//  InstabugInterview
//
//  Created by Yousef Hamza on 1/13/21.
//

import UIKit
import InstabugNetworkClient
import CoreData

class ViewController: UIViewController {
    private var records: [NSManagedObject] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let maxPayLoadSizeMB =  1 * 1024 * 1024
    var numberOfRequests = 0
    var itemRecords: [Record] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        recursive()
        totalRequests(numberOfTimes: 300)
        fetchSavedRecords()
        
        
        //        COMMENTED UNTILL FINAL UPDATE***********
        //        deleteAllData("Record")
    }
    
    
    func save(statusCode: Int, requestpayloadBody: String, method: ApiMethods, url: URL, responsePayLoad: String, completion:(() -> ())?) {
        
        var savedRecord = Record(context: self.context)
        let savedRequest = Request(context: self.context)
        let savedResponse = Response(context: self.context)
        let payloadRequestSize = responsePayLoad.utf8.count
        let payloadResponseSize = responsePayLoad.utf8.count
        
        if statusCode >= 400 {
            if payloadRequestSize > maxPayLoadSizeMB {
                savedRequest.body = "(payload too large)"
            } else {
                savedRequest.body = requestpayloadBody
            }
            savedRequest.httpMethod = method.rawValue
            savedRequest.url = url
            savedResponse.errorCode = Int64(statusCode)
            let errorDomain = HTTPError(rawValue: statusCode)
            savedResponse.errorDomain = errorDomain?.errorDescription

            if payloadResponseSize > maxPayLoadSizeMB {
                savedResponse.payloadBody = "(payload too large)"
            } else {
                savedResponse.payloadBody = responsePayLoad
            }
        } else {
            if payloadRequestSize > maxPayLoadSizeMB {
                savedRequest.body = "(payload too large)"
            } else {
                savedRequest.body  = requestpayloadBody
            }
            savedRequest.httpMethod = method.rawValue
            savedRequest.url = url
            savedResponse.statusCode = Int64(statusCode)
            if payloadResponseSize > maxPayLoadSizeMB {
                savedResponse.payloadBody =  "(payload too large)"
            } else {
                savedResponse.payloadBody = responsePayLoad
            }
        }
            
            savedRecord.addToSavedRequest(savedRequest)
            savedRecord.addToSavedResponse(savedResponse)
        
            
            self.validateOnSavedData {
                do {
                    try self.context.save()
                    self.records.append(savedRecord)
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            
            completion?()
        }
    }
        
    func callPostApi(completion:(() -> ())?) {
            if let postURL = ApiName.binHttpPost.rawValue.url {
                NetworkClient.shared.post(postURL) { [weak self]recievedData, statusCode,errorResponse  in
                    self?.handleResponse(response: recievedData, statusCode: statusCode, requestPayLoad: nil,method: .post, url: postURL, completion: {
                        completion?()
                    })
                }
            }
        }
        
        func callGetApi(completion:(() -> ())?) {
            if let getAuthApi = ApiName.rangeGet.rawValue.url {
                let body = "\(1024 * 1100)"
                let authApi = getAuthApi.appendingPathComponent(body)
                let savedData = "range:\(body)"
                NetworkClient.shared.get(authApi) { [weak self]recievedData, statusCode,errorResponse  in
                    self?.handleResponse(response: recievedData, statusCode: statusCode, requestPayLoad: savedData,method: .get, url: getAuthApi, completion: {
                        completion?()
                    })
                }
            }
        }
    
    func callGetApiFail(name: String, password: String, completion:(() -> ())?) {
        if let getAuthApi = ApiName.binHttpGetAuth.rawValue.url {
            let body = "username\(name),passwd\(password)"
            let authApi = getAuthApi.appendingPathComponent(body)
            let savedData = "range:\(body)"
            NetworkClient.shared.get(authApi) { [weak self]recievedData, statusCode,errorResponse  in
                self?.handleResponse(response: recievedData, statusCode: statusCode, requestPayLoad: savedData,method: .get, url: getAuthApi, completion: {
                    completion?()
                })
            }
        }
    }
        
    func callPutApi(completion:(() -> ())?) {
            if let putApi = ApiName.binHttpPut.rawValue.url {
                NetworkClient.shared.put(putApi) { [weak self]recievedData, statusCode,errorResponse  in
                    self?.handleResponse(response: recievedData, statusCode: statusCode, requestPayLoad: nil,method: .get, url: putApi, completion: {
                        completion?()
                    })
                }
            }
        }
        
        func callDeleteApi(completion:(() -> ())?) {
            if let deleteApi = ApiName.binHttpDelete.rawValue.url {
                NetworkClient.shared.delete(deleteApi) { [weak self]recievedData, statusCode,errorResponse  in
                    self?.handleResponse(response: recievedData, statusCode: statusCode, requestPayLoad: nil,method: .get, url: deleteApi, completion: nil)
                }
            }
        }
    
    func totalRequests(numberOfTimes: Int, completion:(() -> ())?) {
        for _ in 1...numberOfTimes {
            self.numberOfRequests += 1
            self.callPutApi(completion: {
                self.callPostApi(completion: {
//                    self.numberOfRequests += 1
                    self.callGetApi(completion: {
                        self.callDeleteApi(completion: {
                            self.callGetApiFail(name: "mohamed", password: "1234", completion: nil)
                        })
                    })
                })
            })
        }
        completion?()
    }
        
        @discardableResult
        func fetchSavedRecords() -> [Record] {
            do {
                let savedrequests =   try  context.fetch(Record.fetchRequest())
                self.records = savedrequests
                print("RecordsCount\(self.records.count)")
                return savedrequests
            } catch {
                print(error.localizedDescription)
            }
            return []
        }
        
        
        func deleteAllData(_ entity:String) {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
            fetchRequest.returnsObjectsAsFaults = false
            do {
                let results = try context.fetch(fetchRequest)
                for object in results {
                    guard let objectData = object as? NSManagedObject else {continue}
                    context.delete(objectData)
                }
            } catch let error {
                print("Detele all data in \(entity) error :", error)
            }
        }
        
    func validateOnSavedData(completion:(() -> ())?) {
            
            if fetchSavedRecords().count >= 1001 {
                do {
                    let records = try  context.fetch(Record.fetchRequest())
                    print("Before Deletion Count\(records.count)")
//                    records.remove(at: 0)
                    context.delete(records[0])
                    
                    print("After Deletion Count\(records.count)")
                    do {
                        try context.save()
                  
                    } catch let error as NSError {
                        print("Could not remove first record. \(error), \(error.userInfo)")
                    }
                    
                } catch let error {
                    print(error.localizedDescription)
                }
            } else {
                completion?()
            }
        }
        
        
        func isValidPayLoad(payloadData: Data) -> Bool {
            print("PayloadDataSize:\(payloadData.count)")
            if payloadData.count > maxPayLoadSizeMB {
                return false
            } else {
                return true
            }
        }
        
        
        func handleResponse(response: Data?, statusCode: Int, requestPayLoad: String?, method: ApiMethods, url: URL, completion:(() -> ())?) {
            if let data = response {
                if let jsonString = String(data: data, encoding: .utf8) {
                    self.save(statusCode: statusCode, requestpayloadBody: requestPayLoad ?? "", method: method, url: url, responsePayLoad: jsonString, completion: {
                        completion?()
                    })
                }
            } else {
                print("Error handling response")
            }
        }
    
    func isRecordLimitValid(numberOfRecrods: Int) -> Bool {
        totalRequests(numberOfTimes: 100, completion: {
            let numberOfSavedRecords = fetchSavedRecords()
            if numberOfSavedRecords == 1000 {
                return true
            } else {
                return false
            }
        })
    }
}
    
