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
    
    func checkFirestore(completion: @escaping ((String) -> Void))
    func testFirebase()
}

final class ProfileVM: ProfileVMProtocol {
    
    let db = Firestore.firestore()
    
    var message: String = ""
    
    
    // load data in firestore
    func checkFirestore(completion: @escaping ((String) -> Void)) {
        let docRef = db.collection("check").document("Check")

        docRef.getDocument(as: Check.self) { result in
            switch result {
                
            case .success(let check):
                completion(check.message)
                
            case .failure(let error):
                print("Error decoding city: \(error)")
            }
        }
    }
    
    func testFirebase() {
        
    }
}
