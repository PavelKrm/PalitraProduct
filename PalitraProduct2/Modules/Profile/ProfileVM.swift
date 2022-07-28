

import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import UIKit

protocol ProfileVMProtocol {
    
    var options: [ProfileTableView] { get }
    var update: (()->Void)? { get set }

    func signOut()
    func getCurrentUser(completion: @escaping (FBUser) -> Void)
    func getAvatarCarrentUser(completion: @escaping (Data) -> Void)
}

struct ProfileTableView {
    var title: String
    var image: UIImage
    var admin: Bool
}

final class ProfileVM: ProfileVMProtocol {
    
    var userID: String = "" {
        didSet {
            update?()
        }
    }
    
    var update: (() -> Void)?
    
    var currentUserID = AuthService.shared.currentUser?.uid ?? ""

    var options: [ProfileTableView] = [
        ProfileTableView(title: "Мои заказы", image: UIImage(systemName: "cart.fill") ?? UIImage(), admin: true),
        ProfileTableView(title: "Мои клиенты", image: UIImage(systemName: "person.3.fill") ?? UIImage(), admin: false),
        ProfileTableView(title:"Настройки", image: UIImage(systemName: "gearshape.2.fill") ?? UIImage(), admin: false)
    ]

    func signOut() {
        try? Auth.auth().signOut()
    }
    
    func getCurrentUser(completion: @escaping (FBUser) -> Void) {
        DataBaseService.shared.getUser(userID: currentUserID) { result in
            switch result {
            case .success(let user):
                completion(user)
            case .failure(let error):
                print("Error: - \(error.localizedDescription)")
            }
        }
    }
        
        func getAvatarCarrentUser(completion: @escaping (Data) -> Void) {
            StorageService.shared.getUserImage(userID: currentUserID) { result in
                switch result {
                case .success(let data):
                    completion(data)
                case .failure(let error):
                    print("Error: - \(error.localizedDescription)")
                }
            }
        }

}
