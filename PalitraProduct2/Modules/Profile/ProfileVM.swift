

import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import UIKit

protocol ProfileVMProtocol {
    
    var options: [ProfileTableView] { get }
    var optionsAdmin: [ProfileTableView] { get }
    var update: (()->Void)? { get set }
    var admin: Bool { get }

    func signOut()
    func getCurrentUser(completion: @escaping (FBUser) -> Void)
    func getAvatarCarrentUser(completion: @escaping (Data) -> Void)
    func getUserDefault(completion: @escaping (Profile) -> Void)
}

struct ProfileTableView {
    var title: String
    var image: UIImage
    var admin: Bool
}

final class ProfileVM: ProfileVMProtocol {
    
    var admin: Bool = false
    var userID: String = "" {
        didSet {
            update?()
        }
    }
    
    var update: (() -> Void)?
    
    var currentUserID = AuthService.shared.currentUser?.uid ?? ""

    var options: [ProfileTableView] = [
        ProfileTableView(title: "Мои заказы", image: UIImage(systemName: "cart.fill") ?? UIImage(), admin: true),
        ProfileTableView(title: "Мои клиенты", image: UIImage(systemName: "person.3.fill") ?? UIImage(), admin: false)
    ]
    
    var optionsAdmin: [ProfileTableView] = [
        ProfileTableView(title: "Мои заказы", image: UIImage(systemName: "cart.fill") ?? UIImage(), admin: true),
        ProfileTableView(title: "Мои клиенты", image: UIImage(systemName: "person.3.fill") ?? UIImage(), admin: false),
        ProfileTableView(title:"Настройки", image: UIImage(systemName: "gearshape.2.fill") ?? UIImage(), admin: false)
    ]

    func signOut() {
        try? Auth.auth().signOut()
    }
    
    func getUserDefault(completion: @escaping (Profile) -> Void) {
        
        let userDeraults = UserDefaults.standard
        guard let data = userDeraults.data(forKey: "Profile"),
        let profile = try? JSONDecoder().decode(Profile.self, from: data) else { return }
        self.userID = Auth.auth().currentUser?.uid ?? ""
        self.admin = profile.admin
        completion(profile)
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
