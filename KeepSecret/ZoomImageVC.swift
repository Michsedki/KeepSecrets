//
//  ZoomImageVC.swift
//  KeepSecret
//
//  Created by Michael Tanious on 4/17/17.
//  Copyright © 2017 winmacworldIOS. All rights reserved.
//

import UIKit










class ZoomImageVC: UIViewController, UIScrollViewDelegate {

    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    var zoomImage: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        // scroll view zoomin
        scrollView.delegate = self
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 6.0
        loadImage()
        
    }
  

    func loadImage() {
        imageView.image = self.zoomImage
        
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }

    @IBAction func backBTPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: false)
    }
   

}
