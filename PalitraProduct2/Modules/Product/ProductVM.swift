
import Foundation
import CoreData

protocol ProductVMProtocol {
    var products: [Product] { get }
    var typePrices: [TypePrice] { get }
    var update: (() -> Void)? { get set }
    func loadProducts()
    func loadOrder(orderId: String) -> Order
    
}

final class ProductVM: ProductVMProtocol {
    
    static var typePriceID: String = ""
    static var defaultPriceID: String = ""
    static var defaultPriceName: String = ""
    
    var products: [Product] = [] {
        didSet {
            update?()
        }
    }
    
    var update: (() -> Void)?
    
    var typePrices: [TypePrice] = [] {
        didSet {
            for type in typePrices {
                if type.name == "Оптовая" {
                    Self.defaultPriceID = type.id
                    Self.defaultPriceName = type.name
                    Self.typePriceID = type.id
                }
            }
        }
    }
    
    func loadProducts() {
        let request = Product.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Product.name), ascending: true)]
        let products = try? CoreDataService.mainContext.fetch(request)
        self.products = products ?? []
        loadTypePrices(product: products?[0] ?? Product())
    }

    private func loadTypePrices(product: Product) {
        product.allPrices.forEach({
            typePrices.append(TypePrice(id: $0.selfId ?? "", name: $0.name ?? ""))
        })
        
    }
    
    func loadOrder(orderId: String) -> Order {
        if let order = Order.getById(id: orderId) {
            return order
        } else {
            print("ERROR: - \(Self.self) order not found")
        }
        return Order()
    }
}
