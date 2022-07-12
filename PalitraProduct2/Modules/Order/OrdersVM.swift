import Foundation
import CoreData

protocol OrdersVMDelegate {
    
    var order: Order { get set }
    var orders: [Order] { get }
    var update: (() ->Void)? { get set }
    
    func loadDate()
    func removeOrder(order: Order)
    func addOrder(order: Order)
    
}

final class OrdersVM: OrdersVMDelegate {
    
    var order: Order = Order() {
        didSet {
            addOrder(order: order)
        }
    }
    var orders: [Order] = [] {
        didSet {  update?() }
    }
    
    var update: (() -> Void)?
    
    func loadDate() {
        let request = Order.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Order.orderDate), ascending: true)]
        let orders = try? CoreDataService.mainContext.fetch(request)
        self.orders = orders ?? []
    }
    
    func removeOrder(order: Order) {
        CoreDataService.mainContext.delete(order)
    }
    
    func addOrder(order: Order) {
        CoreDataService.mainContext.perform {
            let addingOrder = Order(context: CoreDataService.mainContext)
            addingOrder.selfId = order.selfId
            CoreDataService.saveContext()
        }
        loadDate()
    }
    
}
