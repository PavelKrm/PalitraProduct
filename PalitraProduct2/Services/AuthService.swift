
import Foundation
import FirebaseCore
import FirebaseAuth

final class AuthService {
    
    static let shared = AuthService()
    
    private let auth = Auth.auth()
    
    var currentUser: User? {
        return auth.currentUser
    }
    
    func signUp(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        auth.createUser(withEmail: email, password: password) { result, error in
            if let result = result {
                completion(.success(result.user))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        
        auth.signIn(withEmail: email, password: password) { result, error in
            if let result = result {
                completion(.success(result.user))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    
    func changeEmail(email: String) {
        auth.currentUser?.updateEmail(to: email) { error in
            if let error = error {
                print("Error: - \(error.localizedDescription)")
            }
        }
    }
    
    func changePassword(pass: String, completion: @escaping (Result< String, Error>) -> Void) {
        Auth.auth().currentUser?.updatePassword(to: pass) { error in
            if let error = error {
                completion(.failure(error))
                print("Error: - \(error.localizedDescription)")
            } else {
                completion(.success("Успешно"))
            }
        }
    }
}
