//
//  Contact+CoreDataProperties.swift
//  PalitraProduct2
//
//  Created by Pol Krm on 12.07.22.
//
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var type: String?
    @NSManaged public var view: String?
    @NSManaged public var client: Client?
    @NSManaged public var partner: Partner?

}

extension Contact : Identifiable {

}
