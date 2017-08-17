//
//  Category+CoreDataProperties.swift
//  KeepSecret
//
//  Created by Michael Tanious on 4/13/17.
//  Copyright © 2017 winmacworldIOS. All rights reserved.
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var created: NSDate?
    @NSManaged public var details: String?
    @NSManaged public var image: NSObject?
    @NSManaged public var lastusedate: NSDate?
    @NSManaged public var name: String?
    @NSManaged public var toSecret: NSSet?

}

// MARK: Generated accessors for toSecret
extension Category {

    @objc(addToSecretObject:)
    @NSManaged public func addToToSecret(_ value: Secret)

    @objc(removeToSecretObject:)
    @NSManaged public func removeFromToSecret(_ value: Secret)

    @objc(addToSecret:)
    @NSManaged public func addToToSecret(_ values: NSSet)

    @objc(removeToSecret:)
    @NSManaged public func removeFromToSecret(_ values: NSSet)

}
