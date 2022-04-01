//
//  InstaBugCoreDataTests.swift
//  InstabugNetworkClientTests
//
//  Created by Mohamed Ziad on 01/04/2022.
//

import Foundation
//
//extension InstabugNetworkClientTests {

//
//lazy var managedObjectModel: NSManagedObjectModel = {
//    let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))] )!
//    return managedObjectModel
//}()
//
//lazy var mockPersistantContainer: NSPersistentContainer = {
//
//    let container = NSPersistentContainer(name: "InstabugInterview", managedObjectModel: self.managedObjectModel)
//    let description = NSPersistentStoreDescription()
//    description.type = NSInMemoryStoreType
//    description.shouldAddStoreAsynchronously = false // Make it simpler in test env
//
//    container.persistentStoreDescriptions = [description]
//    container.loadPersistentStores { (description, error) in
//        // Check if the data store is in memory
//        precondition( description.type == NSInMemoryStoreType )
//
//        // Check if creating container wrong
//        if let error = error {
//            fatalError("Create an in-mem coordinator failed \(error)")
//        }
//    }
//    return container
//}()
//    func initStubs() {
//
//        func insertRecordItem( requestURL: String,requestMethod: String ) -> Record? {
//
//            let recordObj =  NSEntityDescription.entity(forEntityName: "Record", in: mockPersistantContainer.viewContext)
//            let requestObj =  NSEntityDescription.entity(forEntityName: "Request", in: mockPersistantContainer.viewContext)
//
//            let responseObj =  NSEntityDescription.entity(forEntityName: "Response", in: mockPersistantContainer.viewContext)
//
//
//            let recordResponseAttr = NSAttributeDescription()
//            recordResponseAttr.name = "response"
//            recordResponseAttr.attributeType = .stringAttributeType
//
//            let requestRequestAttr = NSAttributeDescription()
//            requestRequestAttr.name = "request"
//            requestRequestAttr.attributeType = .stringAttributeType
//
//
//            let requestUrlAttr = NSAttributeDescription()
//            requestUrlAttr.name = "url"
//            requestUrlAttr.attributeType = .stringAttributeType
//
//            let requestUrlMethodAttr = NSAttributeDescription()
//            requestUrlAttr.name = "httpMethod"
//            requestUrlAttr.attributeType = .stringAttributeType
//
//
//            let responseStatusCodeAttr = NSAttributeDescription()
//            responseStatusCodeAttr.name = "statusCode"
//            responseStatusCodeAttr.attributeType = .integer64AttributeType
//            let responsePayloadBodyAttr = NSAttributeDescription()
//            responsePayloadBodyAttr.name = "payloadBody"
//            responsePayloadBodyAttr.attributeType = .stringAttributeType
//            let responseErrorDomainAttr = NSAttributeDescription()
//            responseStatusCodeAttr.name = "errorDomain"
//            responseStatusCodeAttr.attributeType = .stringAttributeType
//            let responseErrorCodeAttr = NSAttributeDescription()
//            responseStatusCodeAttr.name = "errorCode"
//            responseStatusCodeAttr.attributeType = .integer64AttributeType
//
//
//
//
//
//
//
//
//            let recordTorequest = NSRelationshipDescription()
//            recordTorequest.name = "savedRequest"
//            recordTorequest.destinationEntity = recordObj
//            recordTorequest.maxCount = 1
//            recordTorequest.deleteRule = .nullifyDeleteRule
//
//            let requestToRecord = NSRelationshipDescription()
//            requestToRecord.name = "record"
//            requestToRecord.destinationEntity = requestObj
//            requestToRecord.deleteRule = .cascadeDeleteRule
//            requestToRecord.inverseRelationship = recordTorequest
//
//
//            let recordToResponse = NSRelationshipDescription()
//            recordToResponse.name = "savedResponse"
//            recordToResponse.destinationEntity = recordObj
//            recordToResponse.maxCount = 1
//            recordToResponse.deleteRule = .nullifyDeleteRule
//
//            let responseToRecord = NSRelationshipDescription()
//            requestToRecord.name = "record"
//            requestToRecord.destinationEntity = requestObj
//            requestToRecord.deleteRule = .cascadeDeleteRule
//            responseToRecord.inverseRelationship = recordToResponse
//
//            requestToRecord.inverseRelationship = recordTorequest
//
//            recordObj?.properties = [recordResponseAttr,recordResponseAttr ]
//            requestObj?.properties = [requestUrlAttr,requestUrlMethodAttr ]
//            responseObj?.properties = [responseStatusCodeAttr,responsePayloadBodyAttr, responseErrorDomainAttr, responseErrorCodeAttr ]
//
//
//
//
//
//            let newRequest = NSManagedObject(entity: requestObj!, insertInto: mockPersistantContainer.viewContext)
//
//            newRequest.setValue(NSURL(string: requestURL), forKey: "url")
//            newRequest.setValue(requestMethod, forKey: "httpMethod")
//            let savedRequest = recordObj?.mutableSetValue(forKey: "savedRequest")
//            savedRequest?.add(newRequest)
//
//
//            return recordObj as? Record
//        }
//        insertRecordItem(requestURL: "https://httpbin.org/post", requestMethod: "post")
//        insertRecordItem(requestURL: "https://httpbin.org/get", requestMethod: "get")
//        insertRecordItem(requestURL: "https://httpbin.org/put", requestMethod: "put")
//        insertRecordItem(requestURL: "https://httpbin.org/delete", requestMethod: "delete")
//
//
//        do {
//            try mockPersistantContainer.viewContext.save()
//        }  catch {
//            print("create fakes error \(error)")
//        }
//
//    }
//
//    func flushData() {
//
//        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "Record")
//        let objs = try! mockPersistantContainer.viewContext.fetch(fetchRequest)
//        for case let obj as NSManagedObject in objs {
//            mockPersistantContainer.viewContext.delete(obj)
//        }
//        try! mockPersistantContainer.viewContext.save()
//
//    }
    
//}
