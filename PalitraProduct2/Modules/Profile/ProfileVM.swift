//
//  ProfileVM.swift
//  PalitraProduct2
//
//  Created by Павел on 15.07.2022.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol ProfileVMProtocol {
    
    var message: String { get }
    
    func checkFirestore(completion: @escaping ((Check) -> Void))
    func loadProductsInFirebase()
    func updateDocumentFB()
    func udateDocumentCheckFB()
    
}

final class ProfileVM: ProfileVMProtocol {
    
    let db = Firestore.firestore()
    
    var message: String = ""
    
    
    // load data in firestore
    func checkFirestore(completion: @escaping ((Check) -> Void)) {
        let docRef = db.collection("check").document("Check")

        docRef.getDocument(as: Check.self) { result in
            switch result {
                
            case .success(let check):
                completion(check)
                
            case .failure(let error):
                print("Error decoding check: \(error)")
            }
        }
    }
    
    func loadProductsInFirebase() {
        let productsRef = db.collection("products")

        var products: [Product] = []
        
        let request = Product.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Product.name), ascending: true)]
        let product = try? CoreDataService.mainContext.fetch(request)
        products = product ?? []
        
        products.forEach({
            productsRef.document($0.selfId ?? "").setData([
                "id" : "\($0.selfId ?? "")",
                "name" : "\($0.name)",
                "barcode" : "\($0.barcode ?? "")",
                "fee": "\($0.fee ?? "")",
                "percentFee": "\($0.percentFee)",
                "image": "\($0.image ?? "")",
                "manufacturer": "\($0.manufacturer ?? "")",
                "manufacturerId": "\($0.manufacturerId ?? "")",
                "quantity": "\($0.quantity)",
                "unit": "\($0.unit ?? "")",
                "vendorcode": "\($0.vendorcode ?? "")"
            ]) { error in
                if let error = error {
                    print("Error writing document: \(error)")
                } else {
                    print("Document successfully written!")
                }
            }
        })
    }
    
    func updateDocumentFB() {
        
        db.collection("check").document("Check").updateData([
            "lastUpdated": FieldValue.serverTimestamp(),
            "message" : "It's working",
            "checkStatus" : true,
            "historyCheck" : ["\(Date.now)" : ["message" : "It's working"]]
                
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated \(Date.now)")
            }
        }
    }
    
    func udateDocumentCheckFB() {
        db.collection("check").document("Check").updateData([
            "lastUpdated": FieldValue.serverTimestamp(),
            "message" : "check",
            "historyCheck.\(Date.now)" : ["message" : "check"]
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated \(Date.now)")
            }
        }
    }
    
}
