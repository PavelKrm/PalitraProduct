//
//  Group+CoreDataClass.swift
//  PalitraProduct2
//
//  Created by Pol Krm on 12.07.22.
//
//

import Foundation
import CoreData

@objc(Group)
public class Group: NSManagedObject {
    
    var allProduct: [Product] {
            return (product?.allObjects as? [Product]) ?? []
        }

    static func getArrayById(id: String) -> [Group]? {
        let request = Group.fetchRequest()
        request.predicate = NSPredicate(format: "\(#keyPath(Group.parentId)) CONTAINS[cd] \"\(id)\"")
        
        return (try? CoreDataService.mainContext.fetch(request))
    }
    
    static func getById(id: String) -> Group? {
        let request = Group.fetchRequest()
        request.predicate = NSPredicate(format: "\(#keyPath(Group.groupId)) CONTAINS[cd] \"\(id)\"")
        request.fetchLimit = 1
        return (try? CoreDataService.mainContext.fetch(request).first)
    }
    
}
