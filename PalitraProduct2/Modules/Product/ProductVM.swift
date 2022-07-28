
import Foundation
import CoreData

protocol ProductVMProtocol {
    var products: [Product] { get }
    var typePrices: [TypePrice] { get }
    var update: (() -> Void)? { get set }
    func loadData()
    func loadOrder(orderId: String) -> Order
    
}

final class ProductVM: NSObject, ProductVMProtocol {
    
    private var fetchedResultController: NSFetchedResultsController<Product>?
    
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
    
    func loadData() {
        let request = Product.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Product.name), ascending: true)]
        fetchedResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataService.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController?.delegate = self
        loadProducts()
    }
    
    private func loadProducts() {
        try? fetchedResultController?.performFetch()
        self.products = fetchedResultController?.fetchedObjects ?? []
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

extension ProductVM: NSFetchedResultsControllerDelegate {
 
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        loadProducts()
        
    }
}
