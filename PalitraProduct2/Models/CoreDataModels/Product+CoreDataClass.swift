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
    
    var productFB: ProductModel {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.mm.yyyy"
        
        var prices: [ProductPrice] = []
        allPrices.forEach({
            prices.append(ProductPrice(id: $0.selfId ?? "",
                                       name: $0.name ?? "",
                                       price: $0.price,
                                       productId: $0.productId ?? "",
                                       unit: $0.unit ?? "",
                                       lastUpdated: $0.lastUpdated ?? Date()))
        })
        
        let product = ProductModel(id: selfId ?? "",
                                   barcode: barcode ?? "",
                                   fee: fee ?? "",
                                   groupId: groupId ?? "",
                                   image: image ?? "",
                                   manufacturer: manufacturer ?? "",
                                   manufacturerId: manufacturerId ?? "",
                                   name: name,
                                   percentFee: percentFee,
                                   quantity: quantity,
                                   unit: unit ?? "",
                                   vendorcode: vendorcode ?? "",
                                   lastUpdated: lastUpdated ?? Date(),
                                   prices: prices)
        
        return product
    }
}
