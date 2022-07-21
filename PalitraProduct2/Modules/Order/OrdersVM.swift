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
    func sentOrder(order: Order)
    
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
    
    func sentOrder(order: Order) {
        
        let orderRef = db.collection("orders")
        
        let orderData: [String: Any] = [
            "selfId": order.selfId ?? "",
            "orderNumber" : order.orderNumber ?? "",
            "orderDate" : order.orderDate ?? Date(),
            "deliveryDate" : order.deliveryDate ?? "",
            "clientName" : order.client?.clientName ?? "",
            "clientId" : order.client?.clientId ?? "",
            "partnerName" : order.partner?.name ?? "",
            "partnerId" : order.partner?.selfId ?? "",
            "manager" : order.manager ?? "",
            "typePriceName" : order.orderTypePriceName ?? "",
            "typePriceId" : order.orderTypePriceId ?? "",
            "comment" : order.comment ?? "",
            "orderSent" : true,
            "lastUpdated" : FieldValue.serverTimestamp()
        ]
        
        orderRef.document(order.selfId ?? "").setData(orderData) { err in
            
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                CoreDataService.mainContext.perform {
                    if let order = Order.getById(id: order.selfId ?? "") {
                        order.lastUpdated = Date.now
                        order.orderSent = true
                        CoreDataService.saveContext()
                        print("Document \(order.orderNumber ?? "") successfully updated \(Date.now)")
                    }
                }
            }
        }
    }
    
}
