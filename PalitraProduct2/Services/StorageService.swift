
import Foundation
import FirebaseStorage

final class StorageService {
    
    static let shared = StorageService()
    private init() { }
    private let storage = Storage.storage().reference()
    
    private var userRef: StorageReference {
        return storage.child("users")
    }
    
    private var productRef: StorageReference {
        return storage.child("products")
    }
    
    func uploadUserImage(userID: String, image: Data, completion: @escaping (Result<String, Error>) -> Void) {
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        userRef.child(userID).putData(image, metadata: metadata) { metadata, error in
            guard let metadata = metadata else {
                if let error = error {
                    completion(.failure(error))
                }
                return
            }
            completion(.success("Изображение загружено. Размер : \(metadata.size)"))
        }
    }
    
    func getUserImage(userID: String, completion: @escaping (Result<Data, Error>) -> Void) {
        userRef.child(userID).getData(maxSize: 2 * 1024 * 1024) { data, error in
            guard let data = data else {
                if let error = error {
                    completion(.failure(error))
                }
                return
            }
            completion(.success(data))
        }
    }
    
    func uploadProductImage(productID: String, image: Data, completion: @escaping (Result<String, Error>) -> Void) {
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        productRef.child(productID).putData(image, metadata: metadata) { metadata, error in
            guard let metadata = metadata else {
                if let error = error {
                    completion(.failure(error))
                }
                return
            }
            completion(.success("Изображение загружено. Размер : \(metadata.size)"))
        }
    }
    
    func getProductImage(productID: String, completion: @escaping (Result<Data, Error>) -> Void) {
        productRef.child(productID).getData(maxSize: 2 * 1024 * 1024) { data, error in
            guard let data = data else {
                if let error = error {
                    completion(.failure(error))
                }
                return
            }
            completion(.success(data))
        }
    }
}
