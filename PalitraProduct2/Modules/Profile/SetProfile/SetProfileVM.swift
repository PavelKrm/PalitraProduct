
import Foundation
import UIKit

protocol SetProfileVMProtocol {
    
    func uploadImage(image: UIImage)
    func getCurrentUser(completion: @escaping (FBUser) -> Void)
    func saveProfileDefaults(avatar: UIImage, firsName: String, lastname: String, phone: String, completion: @escaping () -> Void)
    func changeEmail(email: String)
    func changePassword(pass: String, completion: @escaping (Result< String, Error>) -> Void)
    func getUserDefault(completion: @escaping (Profile) -> Void)
    
}

final class SetProfileVM: SetProfileVMProtocol {
    
    var user: FBUser!
    
    func getUserDefault(completion: @escaping (Profile) -> Void) {
        
        let userDeraults = UserDefaults.standard
        guard let data = userDeraults.data(forKey: "Profile"),
        let profile = try? JSONDecoder().decode(Profile.self, from: data) else { return }
        completion(profile)
    }
    
    func getCurrentUser(completion: @escaping (FBUser) -> Void) {
        let uid: String = AuthService.shared.currentUser?.uid ?? ""
        DataBaseService.shared.getUser(userID: uid) { result in
            switch result {
            case .success(let user):
                self.user = user
                completion(user)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func uploadImage(image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        StorageService.shared.uploadUserImage(userID: AuthService.shared.currentUser?.uid ?? "", image: imageData) { result in
            switch result {
            case .success(_):
                print("Message: - new image has been upload")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func saveProfileDefaults(avatar: UIImage, firsName: String, lastname: String, phone: String, completion: @escaping () -> Void) {
        
            let userDefaults = UserDefaults.standard
        let profile = Profile(lastname: lastname, firstname: firsName, avatar: avatar, email: user.email, phone: phone, admin: user.admin, acsessApp: user.acsessApp)
            
            if let data = try? JSONEncoder().encode(profile) {
                userDefaults.set(data, forKey: "Profile")
                print("Message: - userDefaults updated")
                completion()
            }
    }
    
    
    
    func changeEmail(email: String) {
        AuthService.shared.changeEmail(email: email)
    }
    
    func changePassword(pass: String, completion: @escaping (Result< String, Error>) -> Void) {
        AuthService.shared.changePassword(pass: pass) { result in
            switch result {
            case .success(let success):
                completion(.success(success))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
    
}
