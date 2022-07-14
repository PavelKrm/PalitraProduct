//
//  OrderProduct+CoreDataProperties.swift
//  PalitraProduct2
//
//  Created by Pol Krm on 12.07.22.
//
//

import Foundation
import CoreData


extension OrderProduct {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OrderProduct> {
        return NSFetchRequest<OrderProduct>(entityName: "OrderProduct")
    }

    @NSManaged public var price: Double
    @NSManaged public var productId: String?
    @NSManaged public var productName: String?
    @NSManaged public var quantity: Int16
    @NSManaged public var selfId: String?
    @NSManaged public var order: Order?

}

extension OrderProduct : Identifiable {

}
