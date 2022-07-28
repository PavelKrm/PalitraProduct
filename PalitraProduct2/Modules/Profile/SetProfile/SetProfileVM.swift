
import Foundation
import UIKit

protocol SetProfileVMProtocol {
    
    func uploadImage(image: UIImage)
    
}

final class SetProfileVM: SetProfileVMProtocol {
    
    var user: FBUser!
    
    func getCurrentUser() {
        let uid: String = AuthService.shared.currentUser?.uid ?? ""
        DataBaseService.shared.getUser(userID: uid) { result in
            switch result {
            case .success(let user):
                self.user = user
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
                print("success")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    func changeEmail() {
//        Auth.auth().currentUser?.updateEmail(to: email) { error in
//              // ...
//            }
    }
    
    func changePassword() {
        
//        Auth.auth().currentUser?.updatePassword(to: password) { error in
//          // ...
//        }
    }
    
}
