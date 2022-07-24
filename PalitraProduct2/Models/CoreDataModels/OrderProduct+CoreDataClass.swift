//
//  OrderProduct+CoreDataClass.swift
//  PalitraProduct2
//
//  Created by Pol Krm on 12.07.22.
//
//

import Foundation
import CoreData

@objc(OrderProduct)
public class OrderProduct: NSManagedObject {
    
    var costWithFee: Double {
        return (((price * percentFee) / 100) + price) * Double(quantity)
    }
    
    var cost: Double {
        return price * Double(quantity)
    }
    
    static func getById(id: String) -> OrderProduct? {
        let request = OrderProduct.fetchRequest()
        request.predicate = NSPredicate(format: "\(#keyPath(OrderProduct.selfId)) CONTAINS[cd] \"\(id)\"")
        request.fetchLimit = 1
        
        return (try? CoreDataService.mainContext.fetch(request))?.first
    }

}
