//
//  Product+CoreDataProperties.swift
//  PalitraProduct2
//
//  Created by Pol Krm on 21.07.22.
//
//

import Foundation
import CoreData


extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var barcode: String?
    @NSManaged public var fee: String?
    @NSManaged public var groupId: String?
    @NSManaged public var image: String?
    @NSManaged public var manufacturer: String?
    @NSManaged public var manufacturerId: String?
    @NSManaged public var name: String
    @NSManaged public var percentFee: Int16
    @NSManaged public var quantity: Int16
    @NSManaged public var selfId: String?
    @NSManaged public var unit: String?
    @NSManaged public var vendorcode: String?
    @NSManaged public var lastUpdated: Date?
    @NSManaged public var group: Group?
    @NSManaged public var prices: NSSet?

}

// MARK: Generated accessors for prices
extension Product {

    @objc(addPricesObject:)
    @NSManaged public func addToPrices(_ value: Price)

    @objc(removePricesObject:)
    @NSManaged public func removeFromPrices(_ value: Price)

    @objc(addPrices:)
    @NSManaged public func addToPrices(_ values: NSSet)

    @objc(removePrices:)
    @NSManaged public func removeFromPrices(_ values: NSSet)

}

extension Product : Identifiable {

}
