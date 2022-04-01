//
//  Request+CoreDataProperties.swift
//  InstabugNetworkClient
//
//  Created by Mohamed Ziad on 01/04/2022.
//
//

import Foundation
import CoreData


extension Request {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Request> {
        return NSFetchRequest<Request>(entityName: "Request")
    }

    @NSManaged public var body: String?
    @NSManaged public var httpMethod: String?
    @NSManaged public var url: URL?
    @NSManaged public var record: Record?

}

extension Request : Identifiable {

}
