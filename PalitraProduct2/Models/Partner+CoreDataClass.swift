//
//  Partner+CoreDataClass.swift
//  PalitraProduct2
//
//  Created by Pol Krm on 12.07.22.
//
//

import Foundation
import CoreData

@objc(Partner)
public class Partner: NSManagedObject {
    
    var allContact: [Contact] {
        return (contact?.allObjects as? [Contact] ?? [])
    }
    
    static func getById(id: String) -> Partner? {
        let request = Partner.fetchRequest()
        request.predicate = NSPredicate(format: "\(#keyPath(Partner.selfId)) CONTAINS[cd] \"\(id)\"")
        request.fetchLimit = 1
        
        return (try? CoreDataService.mainContext.fetch(request))?.first
    }

}
