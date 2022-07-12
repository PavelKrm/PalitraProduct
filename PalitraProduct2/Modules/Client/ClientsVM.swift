
import Foundation
import CoreData

protocol ClientsVMProtocol {
    
    var clients: [Client] { get }
    var update: (() -> Void)? { get set }
    func loadDate()
}

final class ClientsVM: ClientsVMProtocol {
    
    var clients: [Client] = [] {
        didSet {
            update?()
        }
    }
    
    var update: (() -> Void)?
    
    func loadDate() {
        let request = Client.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Client.clientName), ascending: true)]
        let clients = try? CoreDataService.mainContext.fetch(request)
        self.clients = clients ?? []
    }
    
    
}
