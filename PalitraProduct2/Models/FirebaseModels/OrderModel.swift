
import Foundation
import FirebaseFirestore

struct OrderModel {
    var id: String?
    var lastUpdated: Date?
    var orderDate: String?
    var orderNumber: String?
    var deliveryDate: String?
    var typePriceID: String?
    var typePriceName: String?
    var clientId: String?
    var clientName: String
    var partnerId: String?
    var partnerName: String
    var managerID: String?
    var manager: String?
    var comment: String?
    var products = [ProductInOrder]()
    
    var representation: [String : Any] {
        
        var represent = [String : Any]()
        represent["id"] = self.id
        represent["orderDate"] = self.orderDate
        represent["orderNumber"] = self.orderNumber
        represent["deliveryDate"] = self.deliveryDate
        represent["typePriceID"] = self.typePriceID
        represent["typePriceName"] = self.typePriceName
        represent["clientId"] = self.clientId
        represent["clientName"] = self.clientName
        represent["partnerId"] = self.partnerId
        represent["managerID"] = self.managerID
        represent["manager"] = self.manager
        represent["comment"] = self.comment
        represent["lastUpdated"] = FieldValue.serverTimestamp()
        represent["partnerName"] = self.partnerName
        
        return represent
        
    }
    
    var productCount: Int {
        return products.count
    }
    
    var costWithFee: Double {
        var sum: Double = 0.0
        for product in products {
            sum += product.costWithFee
        }
        return sum
    }
    
    var cost: Double {
        var sum: Double = 0.0
        for product in products {
            sum += product.cost
        }
        return sum
    }
}

struct ProductInOrder: Identifiable {
    var id: String
    var productId: String
    var quantity: Int16
    var currentBalance: Int16
    var price: Double
    var productName: String
    var fee: Double
    
    var costWithFee: Double {
        return (((price * fee) / 100) + price) * Double(quantity)
    }
    
    var cost: Double {
        return price * Double(quantity)
    }
    
    var representation: [String : Any] {
        var represent = [String : Any]()
        
        represent["id"] = self.id
        represent["productId"] = self.productId
        represent["quantity"] = self.quantity
        represent["currentBalance"] = self.currentBalance
        represent["price"] = self.price
        represent["productName"] = self.productName
        represent["fee"] = self.fee
        
        return represent
    }
    
}
