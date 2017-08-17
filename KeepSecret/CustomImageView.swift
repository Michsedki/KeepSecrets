//
//  CustomImageView.swift
//  KeepSecret
//
//  Created by Michael Tanious on 4/14/17.
//  Copyright © 2017 winmacworldIOS. All rights reserved.
//

import UIKit

class CustomImageView: UIImageView {
    
    override func awakeFromNib() {
        self.contentMode = .scaleAspectFill
        self.layer.cornerRadius = 34
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        
    }
    
    
    func setImageAndShadow(image: UIImage) {
        self.image = image
        self.superview?.layoutIfNeeded()
        self.clipsToBounds = true
        layer.masksToBounds = true
        layer.cornerRadius = self.frame.height / 2
        layer.shadowOffset = CGSize(width: 0, height: 3.0)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.7
        layer.shadowRadius = 4
        
        
    }
    
    
    
    

}
