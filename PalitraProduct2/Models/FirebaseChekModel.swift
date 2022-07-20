
public struct Check: Codable {
    let message: String
    let checkStatus: Bool?
    
    enum CodingKeys: String, CodingKey {
        case message
        case checkStatus
    }
}

