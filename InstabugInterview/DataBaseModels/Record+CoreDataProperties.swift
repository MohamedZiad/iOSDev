//
//  Record+CoreDataProperties.swift
//  InstabugNetworkClient
//
//  Created by Mohamed Ziad on 01/04/2022.
//
//

import Foundation
import CoreData


extension Record {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Record> {
        return NSFetchRequest<Record>(entityName: "Record")
    }

    @NSManaged public var request: String?
    @NSManaged public var response: String?
    @NSManaged public var savedRequest: NSSet?
    @NSManaged public var savedResponse: NSSet?

}

// MARK: Generated accessors for savedRequest
extension Record {

    @objc(addSavedRequestObject:)
    @NSManaged public func addToSavedRequest(_ value: Request)

    @objc(removeSavedRequestObject:)
    @NSManaged public func removeFromSavedRequest(_ value: Request)

    @objc(addSavedRequest:)
    @NSManaged public func addToSavedRequest(_ values: NSSet)

    @objc(removeSavedRequest:)
    @NSManaged public func removeFromSavedRequest(_ values: NSSet)

}

// MARK: Generated accessors for savedResponse
extension Record {

    @objc(addSavedResponseObject:)
    @NSManaged public func addToSavedResponse(_ value: Response)

    @objc(removeSavedResponseObject:)
    @NSManaged public func removeFromSavedResponse(_ value: Response)

    @objc(addSavedResponse:)
    @NSManaged public func addToSavedResponse(_ values: NSSet)

    @objc(removeSavedResponse:)
    @NSManaged public func removeFromSavedResponse(_ values: NSSet)

}
