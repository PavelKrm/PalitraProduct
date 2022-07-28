
import Foundation
import SwiftUI

protocol AuthVMProtocol {
    
    var users: [FBUser] { get }
    var update: (([String]) -> [String])? { get set}
    var nameUsers: [String] { get }
    
    func getFBUser(username: String)
    func getUsers(completion: @escaping (Result<[String], Error>) -> Void)
    func signIn(pass: String, completion: @escaping () -> Void)
    
}

final class AuthVM: AuthVMProtocol {
    
    var nameUsers: [String] = [] {
        didSet {
//            update?(nameUsers)
        }
    }
    
    private var user: FBUser!
    
    var users: [FBUser] = [] {
        didSet {
            users.forEach({
                nameUsers.append($0.fullname)
            })
        }
    }

    var update: (([String]) -> [String])?
    
    func getUsers(completion: @escaping (Result<[String], Error>) -> Void) {
        DataBaseService.shared.getUsers { result in
            switch result {
            case .success(let users):
                self.users = users
                var nameUsers: [String] = []
                users.forEach({
                    nameUsers.append($0.fullname)
                })
                completion(.success(nameUsers))
            case .failure(let error):
                completion(.failure(error))
                print("Error: - \(error.localizedDescription)")
            }
        }
    }
    
    func signIn(pass: String, completion: @escaping () -> Void) {
        AuthService.shared.signIn(email: self.user.email, password: pass) { result in
            switch result {
            case .success(let user):
                print("Message: - Auth success")
                completion()
                self.getCurrentUser(userID: user.uid)
            case .failure(let error):
                print("Error: - \(error.localizedDescription)")
            }
        }
    }
    
    func getFBUser(username: String){
        var user: FBUser!
        users.forEach({
            if $0.fullname == username {
                user = $0
            }
        })
        self.user = user
    }
    
    private func getCurrentUser(userID: String){
        DataBaseService.shared.getUser(userID: userID) { result in
            switch result {
            case .success(let user):
                self.saveProfileDefaults(user: user)
            case .failure(let error):
                print("Error: - \(error.localizedDescription)")
            }
        }
    }
    
    private func saveProfileDefaults(user: FBUser) {
        
        var image = UIImage(systemName: "nosign")
        getCurrentAvatar(userID: user.id) { data in
            let imageData = UIImage(data: data)
            image = imageData
        }
        
        let userDefaults = UserDefaults.standard
        let profile = Profile(lastname: user.lastname, firstname: user.fullname, avatar: image, email: user.email, phone: user.phone, admin: user.admin, acsessApp: user.acsessApp)
        
        if let data = try? JSONEncoder().encode(profile) {
            userDefaults.set(data, forKey: "Profile")
            print("Message: - userDefaults updated")
        }
    }
    
    private func getCurrentAvatar(userID: String, completion: @escaping (Data) -> Void) {
        StorageService.shared.getUserImage(userID: userID) { result in
            switch result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                print("Error: - \(error.localizedDescription)")
            }
        }
    }
}


