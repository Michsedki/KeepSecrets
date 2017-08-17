//
//  SecretCell.swift
//  KeepSecret
//
//  Created by Michael Tanious on 4/11/17.
//  Copyright © 2017 winmacworldIOS. All rights reserved.
//

import UIKit

class SecretCell: UITableViewCell {

    
    
    @IBOutlet weak var secretImage: UIImageView!
    
    @IBOutlet weak var secretname: UILabel!
    @IBOutlet weak var favoritImage: UIImageView!
    
    @IBOutlet weak var favoritBTLB: UIButton!
  
    
    
    func configureCell(item : Secret) {
        secretImage.image = item.image1 as? UIImage
        secretname.text = item.name
        if item.isfavorit {
            favoritImage.image = UIImage(named: "starfilled")
        } else {
             favoritImage.image = UIImage(named: "starempty")
        }
        
        
        
    }

 

}
