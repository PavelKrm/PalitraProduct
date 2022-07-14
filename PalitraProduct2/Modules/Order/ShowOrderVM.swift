//import Foundation
//
//protocol ShowOrderVMProtocol {
//    
//    var order: Order { get }
//    var update: (() -> Void)? { get set }
//    func loadOrder(_ orderId: String)
//    
//}
//
//final class ShowOrderVM: ShowOrderVMProtocol {
//    
//    var order: Order = Order() {
//        didSet {
//            update?()
//        }
//    }
//
//    var update: (() -> Void)?
//    
//    func loadOrder(_ orderId: String) {
//        order = Order.getById(id: orderId) ?? Order()
//    }
//}
