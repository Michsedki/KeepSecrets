//
//  Category+CoreDataClass.swift
//  KeepSecret
//
//  Created by Michael Tanious on 4/10/17.
//  Copyright © 2017 winmacworldIOS. All rights reserved.
//

import Foundation
import CoreData


public class Category: NSManagedObject {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        self.created = NSDate()
    }
    
    
    
    
    public class func categoryIsExist (insertSecretName: String? , context: NSManagedObjectContext) -> Category? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
        request.predicate = NSPredicate(format: "name =[c] %@", (insertSecretName)!)
        if let foundCategory = (try? context.fetch(request))?.first as? Category {
            return foundCategory
        } else {
            
            
            return nil
            
        }
        
    }
    
    
    
    
    
    
    
//    public class func findOrInseretNewCategory (insert: CategoryItem? , context: NSManagedObjectContext) -> Category? {
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
//        request.predicate = NSPredicate(format: "name =[c] %@", (insert?.name)!)
//        if let _ = (try? context.fetch(request))?.first as? Category {
//            return nil
//        } else {
//            if let newCategory = NSEntityDescription.insertNewObject(forEntityName: "Category", into: context) as? Category {
//                newCategory.name = insert?.name
//                newCategory.image = insert?.image
//                return newCategory
//            }
//        }
//        
//    
//        return nil
//    }

}
