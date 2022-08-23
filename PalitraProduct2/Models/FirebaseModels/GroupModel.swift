
import Foundation
import FirebaseFirestore

struct GroupModel: Identifiable {
    
    var id: String
    var name: String
    var parentId: String
    var lastUpdated: Date
    
    var representation: [String: Any] {
        
        var represent = [String : Any]()
        represent["id"] = self.id
        represent["name"] = self.name
        represent["parentId"] = self.parentId
        represent["lastUpdated"] = Timestamp(date: lastUpdated)
        
        return represent
    }
    
    init?(doc: QueryDocumentSnapshot) {
        
        let data = doc.data()
        
        guard
            let id = data["id"] as? String,
            let name = data["name"] as? String,
            let parentId = data["parentId"] as? String,
            let lastUpdated = data["lastUpdated"] as? Date else { return nil}
            
        self.id = id
        self.name = name
        self.parentId = parentId
        self.lastUpdated = lastUpdated
        
    }
}
