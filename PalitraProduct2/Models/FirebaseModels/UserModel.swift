
import Foundation
import Firebase
struct FBUser: Identifiable {
    
    var id: String
    var firstname: String
    var lastname: String
    var avatar: URL?
    var email: String
    var phone: String
    var admin: Bool
    var acsessApp: Bool
    
    var fullname: String {
        return "\(firstname) \(lastname)"
    }
    
    var representation: [String : Any] {
        
        var represent = [String : Any]()
        represent["id"] = self.id
        represent["firstname"] = self.firstname
        represent["lastname"] = self.lastname
        represent["avatar"] = self.avatar
        represent["email"] = self.email
        represent["phone"] = self.phone
        represent["admin"] = self.admin
        represent["acsessApp"] = self.acsessApp
        
        return represent
    }
    
    init(id: String, firstname: String, lastname: String, avatar: URL?, email: String, phone: String, admin: Bool, acsessApp: Bool ) {
        
        self.id = id
        self.firstname = firstname
        self.lastname = lastname
        self.avatar = avatar
        self.email = email
        self.phone = phone
        self.admin = admin
        self.acsessApp = acsessApp
    }
    
    init?(doc: QueryDocumentSnapshot) {
        
        let data = doc.data()
        
        guard
            let id = data["id"] as? String,
            let firstname = data["firstname"] as? String,
            let lastname = data["lastname"] as? String,
            let avatar = data["avatar"] as? URL,
            let email = data["email"] as? String,
            let phone = data["phone"] as? String,
            let admin = data["admin"] as? Bool,
            let acsessApp = data["acsessApp"] as? Bool else { return nil}
            
        self.id = id
        self.firstname = firstname
        self.lastname = lastname
        self.avatar = avatar
        self.email = email
        self.phone = phone
        self.admin = admin
        self.acsessApp = acsessApp
    }
}
