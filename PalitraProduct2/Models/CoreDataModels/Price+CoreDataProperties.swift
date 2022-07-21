//
//  Price+CoreDataProperties.swift
//  PalitraProduct2
//
//  Created by Pol Krm on 21.07.22.
//
//

import Foundation
import CoreData


extension Price {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Price> {
        return NSFetchRequest<Price>(entityName: "Price")
    }

    @NSManaged public var name: String?
    @NSManaged public var price: Double
    @NSManaged public var productId: String?
    @NSManaged public var selfId: String?
    @NSManaged public var unit: String?
    @NSManaged public var lastUpdated: Date?
    @NSManaged public var product: Product?

}

extension Price : Identifiable {

}
