import Foundation
import CoreData

protocol OrdersVMDelegate {
    
    var orders: [Order] { get }
    var update: (() ->Void)? { get set }
    
    func loadDate()
    func removeOrder(order: Order)
    
}

final class OrdersVM: OrdersVMDelegate {
        
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
        CoreDataService.saveContext()
    }
    
}
