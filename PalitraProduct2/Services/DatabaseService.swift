//
//  DatabaseService.swift
//  PalitraProduct2
//
//  Created by Павел on 22.07.2022.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

final class DataBaseService {
    
    static let shared = DataBaseService()
    
    private let db = Firestore.firestore()
    
    private var ordersRef: CollectionReference {
        return db.collection("orders")
    }
    
    func setOrder(order: OrderModel, completion: @escaping (Result<OrderModel, Error>) -> ()) {
        ordersRef.document(order.id ?? "").setData(order.representation) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                self.setProductsInOrder(to: order.id ?? "", orderProducts: order.products) { result in
                    switch result {
                    case .success(let products):
                        print(products.count)
                        completion(.success(order))
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func setProductsInOrder(to orderId: String, orderProducts: [ProductInOrder], completion: @escaping (Result<[ProductInOrder], Error>) -> ()) {
        
        let orderProductRef = ordersRef.document(orderId).collection("productInOrder")
        
        for orderProduct in orderProducts {
            orderProductRef.document(orderProduct.id).setData(orderProduct.representation)
        }
        completion(.success(orderProducts))
    }
    
}
