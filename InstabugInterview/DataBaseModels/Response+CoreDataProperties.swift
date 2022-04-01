//
//  Response+CoreDataProperties.swift
//  InstabugNetworkClient
//
//  Created by Mohamed Ziad on 01/04/2022.
//
//

import Foundation
import CoreData


extension Response {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Response> {
        return NSFetchRequest<Response>(entityName: "Response")
    }

    @NSManaged public var errorCode: Int64
    @NSManaged public var errorDomain: String?
    @NSManaged public var payloadBody: String?
    @NSManaged public var statusCode: Int64
    @NSManaged public var record: Record?

}

extension Response : Identifiable {

}
