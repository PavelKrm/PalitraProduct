
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
    
    private var usersRef: CollectionReference {
        return db.collection("users")
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
    
    private func setProductsInOrder(to orderId: String, orderProducts: [ProductInOrder], completion: @escaping (Result<[ProductInOrder], Error>) -> ()) {
        
        let orderProductRef = ordersRef.document(orderId).collection("productInOrder")
        
        for orderProduct in orderProducts {
            orderProductRef.document(orderProduct.id).setData(orderProduct.representation)
        }
        completion(.success(orderProducts))
    }
    
    func setUser(user: FBUser, completion: @escaping (Result<FBUser, Error>) -> Void) {
        usersRef.document(user.id).setData(user.representation) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(user))
            }
        }
    }
    
    func getUsers(completion: @escaping (Result<[FBUser], Error>) -> Void) {
        usersRef.getDocuments { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
            } else if let querySnapshot = querySnapshot {
                var users = [FBUser]()
                for document in querySnapshot.documents {
                    if let user = FBUser(doc: document) {
                        users.append(user)
                    }
                }
                completion(.success(users))
            }
        }
    }
    
    func getUser(user: FBUser, completion: @escaping (Result<FBUser, Error>) -> Void) {
        usersRef.document(user.id).getDocument { docSnapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {
               guard let snapshot = docSnapshot,
                     let data = snapshot.data(),
                     let id = data["id"] as? String,
                     let firstname = data["firstname"] as? String,
                     let lastname = data["lastname"] as? String,
                     let avatar = data["avatar"] as? String,
                     let email = data["email"] as? String,
                     let phone = data["phone"] as? String,
                     let admin = data["admin"] as? Bool,
                     let acsessApp = data["acsessApp"] as? Bool else { return }
                
                let user = FBUser(id: id, firstname: firstname, lastname: lastname, avatar: avatar, email: email, phone: phone, admin: admin, acsessApp: acsessApp)
                completion(.success(user))
            }
        }
    }
    
}
