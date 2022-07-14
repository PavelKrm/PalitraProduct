//
//  Client+CoreDataProperties.swift
//  PalitraProduct2
//
//  Created by Pol Krm on 12.07.22.
//
//

import Foundation
import CoreData


extension Client {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Client> {
        return NSFetchRequest<Client>(entityName: "Client")
    }

    @NSManaged public var clientCodeInServer: String?
    @NSManaged public var clientFullName: String?
    @NSManaged public var clientId: String?
    @NSManaged public var clientInfo: String?
    @NSManaged public var clientName: String
    @NSManaged public var comment: String?
    @NSManaged public var counterInfo: String?
    @NSManaged public var counterpartyFullName: String?
    @NSManaged public var counterpartyId: String?
    @NSManaged public var deletionMark: Bool
    @NSManaged public var firstClientId: String?
    @NSManaged public var managerId: String?
    @NSManaged public var registrationDate: String?
    @NSManaged public var unp: String?
    @NSManaged public var contact: NSSet?
    @NSManaged public var order: NSSet?
    @NSManaged public var partner: NSSet?

}

// MARK: Generated accessors for contact
extension Client {

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
extension Client {

    @objc(addOrderObject:)
    @NSManaged public func addToOrder(_ value: Order)

    @objc(removeOrderObject:)
    @NSManaged public func removeFromOrder(_ value: Order)

    @objc(addOrder:)
    @NSManaged public func addToOrder(_ values: NSSet)

    @objc(removeOrder:)
    @NSManaged public func removeFromOrder(_ values: NSSet)

}

// MARK: Generated accessors for partner
extension Client {

    @objc(addPartnerObject:)
    @NSManaged public func addToPartner(_ value: Partner)

    @objc(removePartnerObject:)
    @NSManaged public func removeFromPartner(_ value: Partner)

    @objc(addPartner:)
    @NSManaged public func addToPartner(_ values: NSSet)

    @objc(removePartner:)
    @NSManaged public func removeFromPartner(_ values: NSSet)

}

extension Client : Identifiable {

}
