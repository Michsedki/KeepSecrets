//
//  Picture+CoreDataProperties.swift
//  KeepSecret
//
//  Created by Michael Tanious on 4/15/17.
//  Copyright © 2017 winmacworldIOS. All rights reserved.
//

import Foundation
import CoreData


extension Picture {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Picture> {
        return NSFetchRequest<Picture>(entityName: "Picture")
    }

    @NSManaged public var created: NSDate?
    @NSManaged public var image1: NSObject?
    @NSManaged public var isfavorit: Bool
    @NSManaged public var lastusedate: NSDate?
    @NSManaged public var name: String?
    @NSManaged public var image2: NSObject?

}
