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
    
    var costWithFee: Double {
        var sum: Double = 0.0
        for product in allProduct {
            sum += product.costWithFee
        }
        return sum
    }
    
    var cost: Double {
        var sum: Double = 0.0
        for product in allProduct {
            sum += product.cost
        }
        return sum
    }
    
    var orderModel: OrderModel {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.mm.yyyy"
        
        var productInOrder: [ProductInOrder] = []
        
        allProduct.forEach({
            productInOrder.append(ProductInOrder(id: $0.selfId ?? "",
                                                 productId: $0.productId ?? "",
                                                 quantity: $0.quantity,
                                                 price: $0.price,
                                                 productName: $0.productName ?? "",
                                                 fee: $0.percentFee))
        })
        
        let order = OrderModel(id: selfId,
                               orderDate: dateFormatter.string(from: orderDate ?? Date()),
                               orderNumber: orderNumber,
                               deliveryDate: dateFormatter.string(from: deliveryDate ?? Date()),
                               typePriceID: orderTypePriceId,
                               typePriceName: orderTypePriceName,
                               clientId: client?.clientId,
                               clientName: client?.clientName ?? "",
                               partnerId: partner?.selfId,
                               partnerName: partner?.name ?? "",
                               manager: manager,
                               comment: comment,
                               products: productInOrder)
        
        return order
    }
    
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
