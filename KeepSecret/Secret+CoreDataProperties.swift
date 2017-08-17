//
//  Secret+CoreDataProperties.swift
//  KeepSecret
//
//  Created by Michael Tanious on 4/13/17.
//  Copyright © 2017 winmacworldIOS. All rights reserved.
//

import Foundation
import CoreData


extension Secret {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Secret> {
        return NSFetchRequest<Secret>(entityName: "Secret")
    }

    @NSManaged public var accountnumber: String?
    @NSManaged public var created: NSDate?
    @NSManaged public var email: String?
    @NSManaged public var image1: NSObject?
    @NSManaged public var image2: NSObject?
    @NSManaged public var isfavorit: Bool
    @NSManaged public var lastusedate: NSDate?
    @NSManaged public var name: String?
    @NSManaged public var password1: String?
    @NSManaged public var password2: String?
    @NSManaged public var phonenumber: String?
    @NSManaged public var pinnumber: String?
    @NSManaged public var questionanswer: String?
    @NSManaged public var routingnumber: String?
    @NSManaged public var securityquestion: String?
    @NSManaged public var username: String?
    @NSManaged public var website: String?
    @NSManaged public var zipcode: String?
    @NSManaged public var nickname: String?
    @NSManaged public var toCategory: Category?

}
