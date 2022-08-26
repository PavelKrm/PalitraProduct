
import Foundation
import CoreData

protocol GroupVMProtocol {
    
    var groups: [Group] { get }
    var update: (() -> Void)? { get set }
    func loadGroup(id: String)
}

final class GroupVM: GroupVMProtocol {
    var groups: [Group] = [] {
        didSet {
            update?()
        }
    }
    
    var update: (() -> Void)?
    
    func loadGroup(id: String) {
        self.groups = Group.getArrayById(id: id) ?? []
    }
}
