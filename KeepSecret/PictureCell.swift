//
//  PictureCell.swift
//  KeepSecret
//
//  Created by Michael Tanious on 4/13/17.
//  Copyright © 2017 winmacworldIOS. All rights reserved.
//

import UIKit

class PictureCell: UITableViewCell {

    @IBOutlet weak var pictureImage: UIImageView!
   
    @IBOutlet weak var pictureLB: UILabel!
    @IBOutlet weak var pictureFavoritImage: UIImageView!
    @IBOutlet weak var pictureFavoritBT: UIButton!
   
    func configureCell(item : Picture) {
     pictureLB.text = item.name
        pictureImage.image = item.image1 as? UIImage
        if item.isfavorit {
            pictureFavoritImage.image = UIImage(named: "starfilled")
        } else {
            pictureFavoritImage.image = UIImage(named: "starempty")
        }
        
        
        
        
        
    }
    
    
    
    
    
    
}
