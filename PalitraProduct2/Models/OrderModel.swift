
import Foundation

public struct OrderModel: Codable {
    var id: String?
    var orderDate: String?
    var orderNumber: String?
    var deliveryDate: String?
    var typePrice: String?
    var clientId: String?
    var clientName: String
    var partnerId: String?
    var partnerName: String
    var products: [ProductInOrder]?
}

public struct ProductInOrder: Codable {
    var id: String
    var productId: String
    var quantity: Int16
    var price: Double
    var productName: String
    var fee: Double
}
