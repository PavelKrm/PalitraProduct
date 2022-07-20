
import Foundation

final class Section {
    
    let title: String
    let id: String
    let options: [Group]
    var isOpened: Bool = false
    
    init(title: String, id: String, options: [Group], isOpened: Bool = false) {
        self.title = title
        self.id = id
        self.options = options
        self.isOpened = isOpened
    }
    
}
