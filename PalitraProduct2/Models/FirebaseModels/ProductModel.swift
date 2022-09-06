
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
    var prices: [ProductPrice] = [ProductPrice]() // get products without prices, load prices separately
    
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
    
    init(id: String, barcode: String, fee: String, groupId: String? = nil, image: String? = nil, manufacturer: String, manufacturerId: String, name: String, percentFee: Int16, quantity: Int16, unit: String, vendorcode: String, lastUpdated: Date, prices: [ProductPrice] = [ProductPrice]()) {
        
        self.id = id
        self.barcode = barcode
        self.fee = fee
        self.groupId = groupId
        self.image = image
        self.manufacturer = manufacturer
        self.manufacturerId = manufacturerId
        self.name = name
        self.percentFee = percentFee
        self.quantity = quantity
        self.unit = unit
        self.vendorcode = vendorcode
        self.lastUpdated = lastUpdated
        self.prices = prices
    }
    
    init?(doc: QueryDocumentSnapshot) {
        
        let data = doc.data()
        
        guard
            let id = data["id"] as? String,
            let barcode = data["barcode"] as? String,
            let fee = data["fee"] as? String,
            let groupId = data["groupId"] as? String,
            let image = data["image"] as? String,
            let manufacturer = data["manufacturer"] as? String,
            let manufacturerId = data["manufacturerId"] as? String,
            let name = data["name"] as? String,
            let percentFee = data["percentFee"] as? Int16,
            let quantity = data["quantity"] as? Int16,
            let unit = data["unit"] as? String,
            let vendorcode = data["vendorcode"] as? String,
            let lastUpdated = data["lastUpdated"] as? Timestamp else { return nil}
            
        self.id = id
        self.barcode = barcode
        self.fee = fee
        self.groupId = groupId
        self.image = image
        self.manufacturer = manufacturer
        self.manufacturerId = manufacturerId
        self.name = name
        self.percentFee = percentFee
        self.quantity = quantity
        self.unit = unit
        self.vendorcode = vendorcode
        self.lastUpdated = lastUpdated.dateValue()
    }
}

struct ProductPrice: Identifiable {     // prices model
    
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
