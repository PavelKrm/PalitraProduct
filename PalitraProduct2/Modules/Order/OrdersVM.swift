import Foundation
import CoreData
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift


protocol OrdersVMDelegate {
    
    var orders: [Order] { get }
    var update: (() ->Void)? { get set }
    
    func loadDate()
    func removeOrder(order: Order)
    func sendOrder(_ order: Order)
    
}

final class OrdersVM: OrdersVMDelegate {
    
    let db = Firestore.firestore()
    
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
    
    func sendOrder(_ order: Order) {
        DataBaseService.shared.setOrder(order: order.orderModel) { result in
            switch result {
            case .success(_):
                CoreDataService.mainContext.perform {
                    if let order = Order.getById(id: order.selfId ?? "") {
                        order.lastUpdated = Date.now
                        order.orderSent = true
                        CoreDataService.saveContext()
                        print("Document №\(order.orderNumber ?? "") successfully updated \(Date.now)")
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
