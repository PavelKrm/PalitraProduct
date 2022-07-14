
import Foundation

struct OrderModel {
    var id: String?
    var orderDate: String?
    var orderNumber: String?
    var deliveryDate: String?
    var typePrice: String?
    var clientId: String?
    var partnerId: String?
    var products: [ProductInOrder]?
}
struct ProductInOrder {
    var id: String
    var productId: String
    var quantity: Int16
    var price: Double
    var productName: String
}
