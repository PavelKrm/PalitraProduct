//
//  Order+CoreDataClass.swift
//  PalitraProduct2
//
//  Created by Pol Krm on 12.07.22.
//
//

import Foundation
import CoreData

@objc(Order)
public class Order: NSManagedObject {
    
    var allProduct: [OrderProduct] {
            return (product?.allObjects as? [OrderProduct]) ?? []
        }

    static func getById(id: String) -> Order? {
        let request = Order.fetchRequest()
        request.predicate = NSPredicate(format: "\(#keyPath(Order.selfId)) CONTAINS[cd] \"\(id)\"")
        request.fetchLimit = 1
        
        return (try? CoreDataService.mainContext.fetch(request))?.first
    }

    // Переделать под запрос отправленных/не отправленных заказов
    
//    static func getArrayById(id: String) -> [Client]? {
//        let request = Client.fetchRequest()
//        request.predicate = NSPredicate(format: "\(#keyPath(Client.clientId)) CONTAINS[cd] \"\(id)\"")
//
//        return try? CoreDataService.mainContext.fetch(request)
//    }
}
