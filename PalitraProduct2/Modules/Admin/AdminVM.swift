
import Foundation
import CoreData

protocol AdminVMProtocol {
    
    var users: [FBUser] { get }
    var update: (() -> Void)? { get set }
    func firstLoadData()
    func getUsers(completion: @escaping (Result<[FBUser], Error>) -> Void)
    func uploadProductsInFB(completion: @escaping (Result<String, Error>) -> Void)
    func removeCoreData()
}

final class AdminVM: AdminVMProtocol {
    
    var users: [FBUser] = [] {
        didSet {
            update?()
        }
    }
    
    var update: (() -> Void)?
    
    func firstLoadData() {
        FirstLoadData.shared.readXml()
    }
    
    func getUsers(completion: @escaping (Result<[FBUser], Error>) -> Void) {
        DataBaseService.shared.getUsers { result in
            switch result {
            case .success(let users):
                self.users = users
                completion(.success(users))
            case .failure(let error):
                completion(.failure(error))
                print("Error: - \(error.localizedDescription)")
            }
        }
    }
    
    func uploadProductsInFB(completion: @escaping (Result<String, Error>) -> Void) {
        let request = Product.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Product.name), ascending: true)]
        let products = try? CoreDataService.mainContext.fetch(request)
        var productsSuccess: Int = 0
        var productsFailure: Int = 0
        var imageSuccess: Int = 0
        
//        DispatchQueue.async()
        products?.forEach({ product in
            DataBaseService.shared.setProducts(product: product.productFB) { result in
                switch result {
                case .success(_):
                    productsSuccess += 1
                    if (product.image ?? "") != "" {
                        let image = self.getImage(imagePath: product.image ?? "")
                        StorageService.shared.uploadProductImage(productID: product.productFB.id, image: image) { result in
                            switch result {
                            case .success(_):
                                imageSuccess += 1
                            case .failure(let error):
                                print("Error: - \(error.localizedDescription)")
                            }
                        }
                    }
                case .failure(let error):
                    print("Error: - \(error.localizedDescription)")
                    productsFailure += 1
                }
            }
        })
        completion(.success("Выгружено: \(productsSuccess), ошибок: \(productsFailure), Всего продуктов: \(products?.count ?? 0)"))
    }
    
    private func getImage(imagePath: String) -> Data {
        let path = imagePath.split(separator: ".").first
        let type = imagePath.split(separator: ".").last
        let imagePath = Bundle.main.path(forResource: "\(path ?? "")", ofType: "\(type ?? "")")
        let data = try? Data(contentsOf: URL(fileURLWithPath: imagePath ?? ""))
        return data ?? Data()
    }
    
    func removeCoreData() {
        removeProducts()
        removePrices()
        removeClients()
        removePartners()
        removeGroup()
        removeContacts()
        removeOrders()
        removeProductInOrder()
    }
    
    private func removeProducts() {
        let request = Product.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Product.name), ascending: true)]
        let products = try? CoreDataService.mainContext.fetch(request)
        
        products?.forEach({
            CoreDataService.mainContext.delete($0)
            CoreDataService.saveContext()
        })
    }
    
    private func removePrices() {
        let request = Price.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Price.name), ascending: true)]
        let products = try? CoreDataService.mainContext.fetch(request)
        
        products?.forEach({
            CoreDataService.mainContext.delete($0)
            CoreDataService.saveContext()
        })
    }
    
    private func removeClients() {
        let request = Client.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Client.clientName), ascending: true)]
        let products = try? CoreDataService.mainContext.fetch(request)
        
        products?.forEach({
            CoreDataService.mainContext.delete($0)
            CoreDataService.saveContext()
        })
    }
    
    private func removePartners() {
        let request = Partner.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Partner.name), ascending: true)]
        let products = try? CoreDataService.mainContext.fetch(request)
        
        products?.forEach({
            CoreDataService.mainContext.delete($0)
            CoreDataService.saveContext()
        })
    }
    
    private func removeGroup() {
        let request = Group.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Group.name), ascending: true)]
        let products = try? CoreDataService.mainContext.fetch(request)
        
        products?.forEach({
            CoreDataService.mainContext.delete($0)
            CoreDataService.saveContext()
        })
    }
    
    private func removeContacts() {
        let request = Contact.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Contact.type), ascending: true)]
        let products = try? CoreDataService.mainContext.fetch(request)
        
        products?.forEach({
            CoreDataService.mainContext.delete($0)
            CoreDataService.saveContext()
        })
    }
    
    private func removeOrders() {
        let request = Order.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Order.orderNumber), ascending: true)]
        let products = try? CoreDataService.mainContext.fetch(request)
        
        products?.forEach({
            CoreDataService.mainContext.delete($0)
            CoreDataService.saveContext()
        })
    }
    
    private func removeProductInOrder() {
        let request = OrderProduct.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(OrderProduct.productName), ascending: true)]
        let products = try? CoreDataService.mainContext.fetch(request)
        
        products?.forEach({
            CoreDataService.mainContext.delete($0)
            CoreDataService.saveContext()
        })
    }
}
