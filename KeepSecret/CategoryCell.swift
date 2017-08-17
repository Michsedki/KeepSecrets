//
//  CategoryCell.swift
//  KeepSecret
//
//  Created by Michael Tanious on 4/10/17.
//  Copyright © 2017 winmacworldIOS. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {

    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryName: UILabel!

    func configureCell(item : Category) {
        categoryImage.image = item.image as? UIImage
        categoryName.text = item.name
        
        
        
    }
    
    
    
    
    
    
    
    
}
