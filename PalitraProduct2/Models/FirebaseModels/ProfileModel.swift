import UIKit

final class Profile: Codable {
    
    enum CodingKeys: String, CodingKey {
        case lastname
        case firstname
        case avatar
        case email
        case phone
        case admin
        case acsessApp
    }
    
    var lastname: String
    var firstname: String
    var avatar: UIImage?
    var email: String
    var phone: String
    var admin: Bool
    var acsessApp: Bool
    
    var fullname: String {
        return ("\(firstname) \(lastname)")
    }
    
    init(lastname: String, firstname: String, avatar: UIImage?, email: String, phone: String, admin: Bool, acsessApp: Bool) {
        
        self.lastname = lastname
        self.firstname = firstname
        self.avatar = avatar
        self.email = email
        self.phone = phone
        self.admin = admin
        self.acsessApp = acsessApp
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.lastname, forKey: .lastname)
        try container.encode(self.firstname, forKey: .firstname)
        try container.encode(self.email, forKey: .email)
        try container.encode(self.phone, forKey: .phone)
        try container.encode(self.admin, forKey: .admin)
        try container.encode(self.acsessApp, forKey: .acsessApp)
        
        let data = avatar?.jpegData(compressionQuality: 1.0)
        try container.encode(data, forKey: .avatar)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.firstname = try container.decode(String.self, forKey: .firstname)
        self.lastname = try container.decode(String.self, forKey: .lastname)
        self.email = try container.decode(String.self, forKey: .email)
        self.phone = try container.decode(String.self, forKey: .phone)
        self.admin = try container.decode(Bool.self, forKey: .admin)
        self.acsessApp = try container.decode(Bool.self, forKey: .acsessApp)
        
        if let data = try? container.decode(Data.self, forKey: .avatar) {
            self.avatar = UIImage(data: data)
        }
    }
}
