//
//  ProfileVM.swift
//  PalitraProduct2
//
//  Created by Павел on 15.07.2022.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

protocol ProfileVMProtocol {
    func readDataCheck()
}

final class ProfileVM: ProfileVMProtocol {
    
    let db = Firestore.firestore()
    
    func readDataCheck() {
        
        
        db.collection("check").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
    
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
    }
}
