//
//  Picture+CoreDataClass.swift
//  KeepSecret
//
//  Created by Michael Tanious on 4/13/17.
//  Copyright © 2017 winmacworldIOS. All rights reserved.
//

import Foundation
import CoreData


public class Picture: NSManagedObject {
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        self.created = NSDate()
    }
    
    public class func pictureIsExist (insertSecretName: String? , context: NSManagedObjectContext) -> Picture? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Picture")
        request.predicate = NSPredicate(format: "name =[c] %@", (insertSecretName)!)
        if let foundSecret = (try? context.fetch(request))?.first as? Picture {
            return foundSecret
        } else {
            
            
            return nil
            
        }
        
    }
    
    
    
    

}
