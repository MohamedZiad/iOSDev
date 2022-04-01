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
    var records: [NSManagedObject] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let maxPayLoadSizeMB =  1 * 1024 * 1024
    var numberOfRequests = 0
    var itemRecords: [Record] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        totalRequests(numberOfTimes: 250) {
            print("Finished calling\(self.numberOfRequests)")
        }
    }
    
    private func loadJsonData(file: String) -> Data? {
        //1
        if let jsonFilePath = Bundle(for: type(of:  self)).path(forResource: file, ofType: "json") {
            let jsonFileURL = URL(fileURLWithPath: jsonFilePath)
            //2
            if let jsonData = try? Data(contentsOf: jsonFileURL) {
                return jsonData
            }
        }
        return nil
    }
    
    func save(statusCode: Int, requestpayloadBody: String, method: ApiMethods, url: URL, responsePayLoad: String, payloadRequestSize: Int, payloadResponseSize: Int  ,completion:(() -> ())?) {
        
        let savedRecord = Record(context: self.context)
        let savedRequest = Request(context: self.context)
        let savedResponse = Response(context: self.context)
      
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
                self.itemRecords.append(savedRecord)

                
               
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            completion?()
        }
    }
    
    func callPostApi(completion:(() -> ())?) {
        if let postURL = ApiName.binHttpPost.rawValue.url {
            NetworkClient.shared.post(postURL) { [weak self]recievedData, response,errorResponse  in
                if let urlResponse = response {
                    self?.handleResponse(dataResponse: recievedData, urlResponse: urlResponse, requestPayLoad: nil,method: .post, url: postURL, completion: {
                        completion?()
                    })
                }
                
            }
        }
    }
    
    func callGetApi(completion:(() -> ())?) {
        if let getAuthApi = ApiName.rangeGet.rawValue.url {
            let body = "\(1024 * 1100)"
            let authApi = getAuthApi.appendingPathComponent(body)
            _ = "range:\(body)"
            NetworkClient.shared.get(authApi) { [weak self]recievedData, response,errorResponse  in
                if let urlResponse = response {
                    self?.handleResponse(dataResponse: recievedData, urlResponse: urlResponse, requestPayLoad: nil,method: .get, url: getAuthApi, completion: {
                        completion?()
                    })
                }
            }
        }
    }
    
    func callGetApiFail(name: String, password: String, completion:(() -> ())?) {
        if let getAuthApi = ApiName.binHttpGetAuth.rawValue.url {
            let body = "username\(name),passwd\(password)"
            let authApi = getAuthApi.appendingPathComponent(body)
            _ = "range:\(body)"
            NetworkClient.shared.get(authApi) { [weak self] recievedData, response,errorResponse  in
                if let urlResponse = response {
                    self?.handleResponse(dataResponse: recievedData, urlResponse: urlResponse, requestPayLoad: nil,method: .get, url: getAuthApi, completion: {
                        completion?()
                    })
                }
            }
        }
    }
    
    func callPutApi(completion:(() -> ())?) {
        if let putApi = ApiName.binHttpPut.rawValue.url {
            NetworkClient.shared.put(putApi) { [weak self]recievedData, response,errorResponse  in
                if let urlResponse = response {
                    
                    self?.handleResponse(dataResponse: recievedData, urlResponse: urlResponse, requestPayLoad: nil,method: .put, url: putApi, completion: {
                        completion?()
                    })
                }
            }
        }
    }
    
    func callDeleteApi(completion:(() -> ())?) {
        if let deleteApi = ApiName.binHttpDelete.rawValue.url {
            NetworkClient.shared.delete(deleteApi) { [weak self]recievedData, response,errorResponse  in
                if let urlResponse = response {
                    self?.handleResponse(dataResponse: recievedData, urlResponse: urlResponse , requestPayLoad: nil,method: .get, url: deleteApi, completion: nil)
                }
            }
        }
    }
    
    func totalRequests(numberOfTimes: Int, completion:(() -> ())?) {
     
            while true {
            self.numberOfRequests += 1
            self.callPutApi(completion: {
                self.callPostApi(completion: {
                    self.callGetApi(completion: {
                        self.callDeleteApi(completion: {
                            self.callGetApiFail(name: "mohamed", password: "1234", completion: nil)
                        })
                    })
                })
            })
            if numberOfRequests == 1000 {
                completion?()
                break
            }
        }
        
    }
    
    func isValidRequestPayload(requestPayloadSize: Int) -> Bool {
        var data = Data()
        data.count = requestPayloadSize
        if requestPayloadSize >  maxPayLoadSizeMB {
            return false
        } else {
            return true
        }
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
                context.delete(records[0])
                do {
                    try context.save()
                    
                } catch let error as NSError {
                    print("Could not remove first record. \(error), \(error.userInfo)")
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
            completion?()
    }
    
    func isValidPayLoad(payloadData: Data) -> Bool {
        print("PayloadDataSize:\(payloadData.count)")
        if payloadData.count > maxPayLoadSizeMB {
            return false
        } else {
            return true
        }
    }
    
    func handleResponse(dataResponse: Data?, urlResponse: URLResponse, requestPayLoad: String?, method: ApiMethods, url: URL, completion:(() -> ())?) {
        guard let response = urlResponse as? HTTPURLResponse else { return }
        if let data = dataResponse, let jsonString = String(data: data, encoding: .utf8) {
            self.save(statusCode: response.statusCode, requestpayloadBody: requestPayLoad ?? "", method: method, url: url, responsePayLoad: jsonString,payloadRequestSize: 0, payloadResponseSize: data.count  ,completion: {
                completion?()
            })
            
        } else {
            self.save(statusCode: response.statusCode, requestpayloadBody: requestPayLoad ?? "", method: method, url: url, responsePayLoad: "",payloadRequestSize: 0, payloadResponseSize: 0  ,completion: {
                completion?()
            })
        }
    }
}


