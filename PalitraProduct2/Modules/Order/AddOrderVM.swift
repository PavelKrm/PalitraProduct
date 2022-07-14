////
////  AddOrderVM.swift
////  PalitraProduct2
////
////  Created by Павел on 13.07.2022.
////
//
//import Foundation
//
//protocol AddOrderVMProtocol {
//    
//    var order: OrderModel { get set }
//    var update: (() -> Void)? { get set }
//    func setOrder(_ property: String)
//    
//    func setProductOnOrder(product: ProductInOrder)
//    
//}
//
//final class AddOrderVM: AddOrderVMProtocol {
//    
//    var order: OrderModel = OrderModel() {
//        didSet {
//            update?()
//        }
//    }
//    
//    var update: (() -> Void)?
//    
//    func setOrder(property: String, value: String) {
//        order.
//    }
//    
//    func setProductOnOrder(product: ProductInOrder) {
//        order.products?.append(product)
//    }
//    
//    
//    
//    
//}
