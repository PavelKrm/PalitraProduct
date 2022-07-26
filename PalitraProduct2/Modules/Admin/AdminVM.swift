
import Foundation

protocol AdminVMProtocol {
    
    func firstLoadData()
}

final class AdminVM: AdminVMProtocol {
    
    func firstLoadData() {
        
        FirstLoadData.readXml()
    }
}
