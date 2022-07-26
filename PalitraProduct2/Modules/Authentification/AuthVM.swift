
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
                print(error.localizedDescription)
            }
        }
    }
    
    func signIn(pass: String, completion: @escaping () -> Void) {
        AuthService.shared.signIn(email: self.user.email, password: pass) { result in
            switch result {
            case .success(_):
                print("Auth success")
                completion()
            case .failure(let error):
                print(error.localizedDescription)
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
}


