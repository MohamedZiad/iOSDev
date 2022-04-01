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
    
    
    
    func insertRecordItem( Request: Request, Response: Response ) -> Record? {
        guard let recordItem = NSEntityDescription.insertNewObject(forEntityName: "Record", into: backgroundContext) as? Record else { return nil }
        recordItem.addToSavedRequest(Request)
        recordItem.addToSavedResponse(Response)

        return recordItem
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
    
    
    func initStubs() {
            
        func insertRecordItem( requestURL: String,requestMethod: String ) -> Record? {
           
            let recordObj =  NSEntityDescription.entity(forEntityName: "Record", in: mockPersistantContainer.viewContext)
            let requestObj =  NSEntityDescription.entity(forEntityName: "Request", in: mockPersistantContainer.viewContext)
            let responseObj =  NSEntityDescription.entity(forEntityName: "Response", in: mockPersistantContainer.viewContext)
            
//
            let newRequest = NSManagedObject(entity: requestObj!, insertInto: mockPersistantContainer.viewContext)
            newRequest.setValue(requestURL, forKey: "url")
            newRequest.setValue(requestMethod, forKey: "httpMethod")
            let savedRequest = recordObj?.mutableSetValue(forKey: "savedRequest")
            savedRequest?.add(newRequest)
            
//           let responseObj =  obj.entity.mutableSetValue(forKey: "savedResponse")
////            obj.setValue(name, forKey: "name")
////            obj.setValue(finished, forKey: "finished")
//
            return recordObj as? Record
        }
        insertRecordItem(requestURL: "https://httpbin.org/post", requestMethod: "post")
        insertRecordItem(requestURL: "https://httpbin.org/get", requestMethod: "get")
        insertRecordItem(requestURL: "https://httpbin.org/put", requestMethod: "put")
        insertRecordItem(requestURL: "https://httpbin.org/delete", requestMethod: "delete")


        do {
            try mockPersistantContainer.viewContext.save()
        }  catch {
            print("create fakes error \(error)")
        }
            
    }
    
    func flushData() {
            
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "Record")
        let objs = try! mockPersistantContainer.viewContext.fetch(fetchRequest)
        for case let obj as NSManagedObject in objs {
            mockPersistantContainer.viewContext.delete(obj)
        }
        try! mockPersistantContainer.viewContext.save()

    }
    
}
