//
//  Partner+CoreDataProperties.swift
//  PalitraProduct2
//
//  Created by Pol Krm on 12.07.22.
//
//

import Foundation
import CoreData


extension Partner {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Partner> {
        return NSFetchRequest<Partner>(entityName: "Partner")
    }

    @NSManaged public var codeInServer: String?
    @NSManaged public var comment: String?
    @NSManaged public var deletionMark: Bool
    @NSManaged public var info: String?
    @NSManaged public var managerId: String?
    @NSManaged public var name: String
    @NSManaged public var parentId: String?
    @NSManaged public var registrationDate: String?
    @NSManaged public var selfId: String?
    @NSManaged public var client: Client?
    @NSManaged public var contact: NSSet?
    @NSManaged public var order: NSSet?

}

// MARK: Generated accessors for contact
extension Partner {

    @objc(addContactObject:)
    @NSManaged public func addToContact(_ value: Contact)

    @objc(removeContactObject:)
    @NSManaged public func removeFromContact(_ value: Contact)

    @objc(addContact:)
    @NSManaged public func addToContact(_ values: NSSet)

    @objc(removeContact:)
    @NSManaged public func removeFromContact(_ values: NSSet)

}

// MARK: Generated accessors for order
extension Partner {

    @objc(addOrderObject:)
    @NSManaged public func addToOrder(_ value: Order)

    @objc(removeOrderObject:)
    @NSManaged public func removeFromOrder(_ value: Order)

    @objc(addOrder:)
    @NSManaged public func addToOrder(_ values: NSSet)

    @objc(removeOrder:)
    @NSManaged public func removeFromOrder(_ values: NSSet)

}

extension Partner : Identifiable {

}
