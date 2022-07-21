import Foundation

public struct Check: Codable {
    let message: String
    let checkStatus: Bool?
    let lastUpdated: Date
    let historyCheck: [HistoryCheck : History]
    
    enum CodingKeys: String, CodingKey {
        case message
        case checkStatus
        case lastUpdated
        case historyCheck
    }
}

public struct HistoryCheck: Codable, Hashable {
    let date: Date
    
    enum CodingKeys: String, CodingKey {
        case date
    }
}

public struct History: Codable {
    var message: String
    
    enum CodingKeys: String, CodingKey {
        case message
    }
}
