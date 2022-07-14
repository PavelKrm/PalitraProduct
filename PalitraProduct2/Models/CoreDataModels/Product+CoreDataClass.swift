//
//  Product+CoreDataClass.swift
//  PalitraProduct2
//
//  Created by Pol Krm on 12.07.22.
//
//

import Foundation
import CoreData

@objc(Product)
public class Product: NSManagedObject {

    var allPrices: [Price] {
            return (prices?.allObjects as? [Price]) ?? []
        }

        static func getById(id: String) -> Product? {
            let request = Product.fetchRequest()
            request.predicate = NSPredicate(format: "\(#keyPath(Product.selfId)) CONTAINS[cd] \"\(id)\"")
            request.fetchLimit = 1
            
            return (try? CoreDataService.mainContext.fetch(request))?.first
        }
    
}
