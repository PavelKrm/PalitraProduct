
import Foundation

protocol AuthVMProtocol {
    
    var users: [FBUser] { get }
//    var user: FBUser { get }
    
    func getUsers()
    func signIn(user: FBUser, pass: String)
    
}

final class AuthVM: AuthVMProtocol {
    
    var users: [FBUser] = []
    
    func getUsers() {
        DataBaseService.shared.getUsers { result in
            switch result {
            case .success(let users):
                self.users = users
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func signIn(user: FBUser, pass: String) {
        AuthService.shared.signIn(email: user.email, password: pass) { result in
            switch result {
            case .success(_):
                <#code#>
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}


