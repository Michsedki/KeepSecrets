//
//  Secret+CoreDataClass.swift
//  KeepSecret
//
//  Created by Michael Tanious on 4/10/17.
//  Copyright © 2017 winmacworldIOS. All rights reserved.
//

import Foundation
import CoreData


public class Secret: NSManagedObject {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        self.created = NSDate()
    }
    
    
    public class func secretIsExist (insertSecretName: String? , context: NSManagedObjectContext) -> Secret? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Secret")
        request.predicate = NSPredicate(format: "name =[c] %@", (insertSecretName)!)
        if let foundSecret = (try? context.fetch(request))?.first as? Secret {
            return foundSecret
        } else {
           
                
                return nil
            
        }
        
    }

    
    
//    public class func findOrInseretNewSecret (insert: secretItem? , context: NSManagedObjectContext) -> Secret? {
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Secret")
//        request.predicate = NSPredicate(format: "name = %@", (insert?.name)!)
//        if let foundSecret = (try? context.fetch(request))?.first as? Secret {
//            return nil
//        } else {
//            if let newCategory = NSEntityDescription.insertNewObject(forEntityName: "Secret", into: context) as? Secret {
//                newCategory.name = insert?.name
//                newCategory.email = insert?.email
//                newCategory.website = insert?.website
//                newCategory.username = insert?.username
//                newCategory.password1 = insert?.password1
//                newCategory.password2 = insert?.password2
//                newCategory.phonenumber = insert?.phonenumber
//                newCategory.zipcode = insert?.zipcode
//                newCategory.pinnumber = insert?.pinnumber
//                newCategory.securityquestion = insert?.securityquestion
//                newCategory.questionanswer = insert?.questionanswer
//                newCategory.image1 = insert?.image1
//                newCategory.image2 = insert?.image2
//                newCategory.toCategory = insert?.toCategory
//               
//                return newCategory
//            }
//        }
//        
//        
//        return nil
//    }

        
    

}
