
import Foundation
import Firebase

struct ProductModel {
    
    var id: String
    var barcode: String
    var fee: String
    var groupId: String?
    var image: String?
    var manufacturer: String
    var manufacturerId: String
    var name: String
    var percentFee: Int16
    var quantity: Int16
    var unit: String
    var vendorcode: String
    var lastUpdated: Date
    var prices: [ProductPrice]
    
    var representation: [String : Any] {
        
        var represent = [String : Any]()
        represent["id"] = self.id
        represent["barcode"] = self.barcode
        represent["fee"] = self.fee
        represent["groupId"] = self.groupId
        represent["image"] = self.image
        represent["manufacturer"] = self.manufacturer
        represent["manufacturerId"] = self.manufacturerId
        represent["name"] = self.name
        represent["percentFee"] = self.percentFee
        represent["quantity"] = self.quantity
        represent["unit"] = self.unit
        represent["vendorcode"] = self.vendorcode
        represent["lastUpdated"] = Timestamp(date: lastUpdated)
        
        return represent
        
    }
    
}

struct ProductPrice: Identifiable {
    
    var id: String
    var name: String
    var price: Double
    var productId: String
    var unit: String
    var lastUpdated: Date
    
    var representation: [String : Any] {
        
        var represent = [String : Any]()
        
        represent["id"] = self.id
        represent["name"] = self.name
        represent["price"] = self.price
        represent["productId"] = self.productId
        represent["unit"] = self.unit
        represent["lastUpdated"] = self.lastUpdated
        
        return represent
    }
    
}
