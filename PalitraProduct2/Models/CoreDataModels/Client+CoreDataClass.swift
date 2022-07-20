//
//  Client+CoreDataClass.swift
//  PalitraProduct2
//
//  Created by Pol Krm on 12.07.22.
//
//

import Foundation
import CoreData

@objc(Client)
public class Client: NSManagedObject {

    var allPartner: [Partner] {
        print(partner?.allObjects as? [Partner] ?? Partner())
            return (partner?.allObjects as? [Partner]) ?? []
        
        }
    var allContact: [Contact] {
        return (contact?.allObjects as? [Contact] ?? [])
    }

        static func getById(id: String) -> Client? {
            let request = Client.fetchRequest()
            request.predicate = NSPredicate(format: "\(#keyPath(Client.clientId)) CONTAINS[cd] \"\(id)\"")
            request.fetchLimit = 1
            
            return (try? CoreDataService.mainContext.fetch(request))?.first
        }
    
    static func getArrayById(id: String) -> [Client]? {
        let request = Client.fetchRequest()
        request.predicate = NSPredicate(format: "\(#keyPath(Client.clientId)) CONTAINS[cd] \"\(id)\"")
        
        return try? CoreDataService.mainContext.fetch(request)
    }
}
