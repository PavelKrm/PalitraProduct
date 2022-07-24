import Foundation

public struct Check: Codable {
    let message: String
    let checkStatus: Bool?
    let lastUpdated: Date
    let historyCheck: [HistoryCheck]

    enum CodingKeys: String, CodingKey {
        case message
        case checkStatus
        case lastUpdated
        case historyCheck
    }
}

public struct HistoryCheck: Codable, Hashable {

    let date: Date
    let history: [History]

    enum CodingKeys: String, CodingKey {
        case date
        case history
    }
}

public struct History: Codable, Hashable {
    var message: String

    enum CodingKeys: String, CodingKey {
        case message
    }
}

//public struct Check {
//        let message: String
//        let checkStatus: Bool?
//        let lastUpdated: Date
//        let historyCheck: [HistoryCheck]
//
//    var representation: [String : Any] {
//
//        var represent = [String : Any]()
//        represent["message"] = self.message
//        represent["checkStatus"] = self.checkStatus
//        represent["lastUpdated"] = self.lastUpdated
//        represent["historyCheck"] = self.historyCheck
//
//        return represent
//    }
//}
//
//public struct HistoryCheck{
//
//    let date: Date
//    let history: [History]
//
//    var representation: [String: Any] {
//        var represent = [String : Any]()
//
//        represent["date"] = self.date
//        represent["history"] = self.history
//
//        return represent
//    }
//}
//
//public struct History{
//    var message: String
//
//    var representation: [String: Any] {
//
//            var represent = [String : Any]()
//            represent["message"] = self.message
//            return represent
//        }
//}
