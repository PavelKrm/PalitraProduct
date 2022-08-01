
import Foundation
import UIKit
import FirebaseAuth

protocol AddUserVMProtocol {
    func getUserProfile(userID: String, completion: @escaping (Profile) -> Void)
    func updateUser(id: String, firstName: String, lastname: String, avatar: UIImage, email: String, phone: String, admin: Bool, acsessApp: Bool, completion: @escaping (Result<FBUser, Error>) -> Void)
    func signUpUser(email: String, pass: String, completion: @escaping (Result<User, Error>) -> Void)
}

final class AddUserVM: AddUserVMProtocol {
    
    func getUserProfile(userID: String, completion: @escaping (Profile) -> Void) {
        DataBaseService.shared.getUser(userID: userID) { result in
            switch result {
            case .success(let user):
                StorageService.shared.getUserImage(userID: user.id) { result in
                    switch result {
                    case .success(let avatar):
                        let image = UIImage(data: avatar)
                        let profile = Profile(lastname: user.lastname,
                                              firstname: user.firstname,
                                              avatar: image,
                                              email: user.email,
                                              phone: user.phone,
                                              admin: user.admin,
                                              acsessApp: user.acsessApp)
                        completion(profile)
                    case .failure(let error):
                        let image = UIImage(systemName: "nosgn")
                        let profile = Profile(lastname: user.lastname,
                                              firstname: user.firstname,
                                              avatar: image,
                                              email: user.email,
                                              phone: user.phone,
                                              admin: user.admin,
                                              acsessApp: user.acsessApp)
                        completion(profile)
                        print("Error: - \(error.localizedDescription)")
                    }
                }
            case .failure(let error):
                print("Error: - \(error.localizedDescription)")
            }
        }
    }
    
    func updateUser(id: String, firstName: String, lastname: String, avatar: UIImage, email: String, phone: String, admin: Bool, acsessApp: Bool, completion: @escaping (Result<FBUser, Error>) -> Void) {
        let user = FBUser(id: id, firstname: firstName, lastname: lastname, avatar: id, email: email, phone: phone, admin: admin, acsessApp: acsessApp)
        DataBaseService.shared.setUser(user: user) { result in
            switch result {
            case .success(let user):
                if let data = avatar.jpegData(compressionQuality: 0.5) {
                    StorageService.shared.uploadUserImage(userID: user.id, image: data) { result in
                        switch result {
                        case .success(let message):
                            print("Message: - \(message)")
                            completion(.success(user))
                        case .failure(let error):
                            print("Error: - \(error)")
                        }
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func signUpUser(email: String, pass: String, completion: @escaping (Result<User, Error>) -> Void) {
        AuthService.shared.signUp(email: email, password: pass) { result in
            switch result {
            case .success(let user):
                completion(.success(user))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
