//
//  MockContainerManager.swift
//  InstabugInterview
//
//  Created by Mohamed Ziad on 31/03/2022.
//

import UIKit
import CoreData
class MockContainerManager {
    
    let persistentContainer: NSPersistentContainer!
    
    //MARK: Init with dependency
    init(container: NSPersistentContainer) {
        self.persistentContainer = container
        self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    convenience init() {
        //Use the default container for production environment
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Can not get shared app delegate")
        }
        self.init(container: appDelegate.persistentContainer)
    }
    
    lazy var backgroundContext: NSManagedObjectContext = {
            return self.persistentContainer.newBackgroundContext()
        }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
            let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))] )!
            return managedObjectModel
        }()
    
    lazy var mockPersistantContainer: NSPersistentContainer = {
            
            let container = NSPersistentContainer(name: "InstabugInterview", managedObjectModel: self.managedObjectModel)
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            description.shouldAddStoreAsynchronously = false // Make it simpler in test env
            
            container.persistentStoreDescriptions = [description]
            container.loadPersistentStores { (description, error) in
                // Check if the data store is in memory
                precondition( description.type == NSInMemoryStoreType )
                                            
                // Check if creating container wrong
                if let error = error {
                    fatalError("Create an in-mem coordinator failed \(error)")
                }
            }
            return container
        }()
    
    
    
    func insertRecordItem( requestURL: String,requestMethod: String ) -> Record? {
       
        let recordObj =  NSEntityDescription.entity(forEntityName: "Record", in: persistentContainer .viewContext)
        let requestObj =  NSEntityDescription.entity(forEntityName: "Request", in: persistentContainer.viewContext)
        
        
        
        let requestUrlAttr = NSAttributeDescription()
        requestUrlAttr.name = "url"
        requestUrlAttr.attributeType = .stringAttributeType
        
        let requestUrlMethodAttr = NSAttributeDescription()
        requestUrlAttr.name = "httpMethod"
        requestUrlAttr.attributeType = .stringAttributeType
        
        requestObj?.properties = [requestUrlAttr,requestUrlMethodAttr ]
        
        
       
        
        let recordTorequest = NSRelationshipDescription()
        recordTorequest.name = "savedRequest"
        recordTorequest.destinationEntity = recordObj
        recordTorequest.maxCount = 1
        recordTorequest.deleteRule = .nullifyDeleteRule
        
        let requestToRecord = NSRelationshipDescription()
        requestToRecord.name = "record"
        requestToRecord.destinationEntity = requestObj
        requestToRecord.deleteRule = .cascadeDeleteRule
        
        requestToRecord.inverseRelationship = recordTorequest
        
        
        let responseObj =  NSEntityDescription.entity(forEntityName: "Response", in: mockPersistantContainer.viewContext)
        
//        managedObjectModel.entities = [ recordObj, requestObj, responseObj ]

//
        let newRequest = NSManagedObject(entity: requestObj!, insertInto: mockPersistantContainer.viewContext)
        
        newRequest.setValue(NSURL(string: requestURL), forKey: "url")
        newRequest.setValue(requestMethod, forKey: "httpMethod")
        let savedRequest = recordObj?.mutableSetValue(forKey: "savedRequest")
        savedRequest?.add(newRequest)

        return recordObj as? Record
    }

    func fetchAll() -> [Record] {
        let request: NSFetchRequest<Record> = Record.fetchRequest()
        let results = try? persistentContainer.viewContext.fetch(request)
        return results ?? [Record]()
    }

    func remove( objectID: NSManagedObjectID ) {
        let obj = backgroundContext.object(with: objectID)
        backgroundContext.delete(obj)
    }

    func save() {
        if backgroundContext.hasChanges {
            do {
                try backgroundContext.save()
            } catch {
                print("Save error \(error)")
            }
        }

    }
    
    
   
}
