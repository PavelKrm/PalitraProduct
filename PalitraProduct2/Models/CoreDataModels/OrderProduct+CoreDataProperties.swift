//
//  OrderProduct+CoreDataProperties.swift
//  PalitraProduct2
//
//  Created by Павел on 03.08.2022.
//
//

import Foundation
import CoreData


extension OrderProduct {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OrderProduct> {
        return NSFetchRequest<OrderProduct>(entityName: "OrderProduct")
    }

    @NSManaged public var lastUpdated: Date?
    @NSManaged public var percentFee: Double
    @NSManaged public var price: Double
    @NSManaged public var productId: String?
    @NSManaged public var productName: String?
    @NSManaged public var quantity: Int16
    @NSManaged public var selfId: String?
    @NSManaged public var currentBalance: Int16
    @NSManaged public var order: Order?

}

extension OrderProduct : Identifiable {

}
