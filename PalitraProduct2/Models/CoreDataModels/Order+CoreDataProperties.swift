//
//  Order+CoreDataProperties.swift
//  PalitraProduct2
//
//  Created by Pol Krm on 21.07.22.
//
//

import Foundation
import CoreData


extension Order {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Order> {
        return NSFetchRequest<Order>(entityName: "Order")
    }

    @NSManaged public var comment: String?
    @NSManaged public var deliveryDate: Date?
    @NSManaged public var manager: String?
    @NSManaged public var orderDate: Date?
    @NSManaged public var orderNumber: String?
    @NSManaged public var orderSent: Bool
    @NSManaged public var orderTypePriceId: String?
    @NSManaged public var orderTypePriceName: String?
    @NSManaged public var selfId: String?
    @NSManaged public var lastUpdated: Date?
    @NSManaged public var client: Client?
    @NSManaged public var partner: Partner?
    @NSManaged public var product: NSSet?

}

// MARK: Generated accessors for product
extension Order {

    @objc(addProductObject:)
    @NSManaged public func addToProduct(_ value: OrderProduct)

    @objc(removeProductObject:)
    @NSManaged public func removeFromProduct(_ value: OrderProduct)

    @objc(addProduct:)
    @NSManaged public func addToProduct(_ values: NSSet)

    @objc(removeProduct:)
    @NSManaged public func removeFromProduct(_ values: NSSet)

}

extension Order : Identifiable {

}
