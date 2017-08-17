//
//  PictureDetailsVC.swift
//  KeepSecret
//
//  Created by Michael Tanious on 4/14/17.
//  Copyright © 2017 winmacworldIOS. All rights reserved.
//

import UIKit

class PictureDetailsVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate {
    
    
    
    @IBOutlet weak var pictureImage1LB: UIImageView!
    
    @IBOutlet weak var pictureImage2LB: UIImageView!
    
   
    
    @IBOutlet weak var pictureTitleTXT: UITextField!
    
    @IBOutlet weak var favoritImage: UIImageView!
    
    
    // Variables
    var pictureToEdit: Picture?
    var imagePicker: UIImagePickerController!
    var isFavorit = false
    var imagePicked = 0
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if pictureToEdit != nil {
            self.title = "Edit Picture"
            
            loadPictureData()
        } else {
            self.title = "Add Picture"
        }
        
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        self.hideKeyboardOnTap(#selector(self.dismissKeyboard))
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        
        
        addGuestures()
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    // prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowZoomImageVC" {
            if let des = segue.destination as? ZoomImageVC {
                if let item = sender as? UIImageView {
                    des.zoomImage = item.image
                }
            }
        }
    }
    
    func loadPictureData() {
        if let item = pictureToEdit {
            pictureImage1LB.image = item.image1 as? UIImage
            pictureImage2LB.image = item.image2 as? UIImage
            
            pictureTitleTXT.text = item.name
            if item.isfavorit {
                favoritImage.image = UIImage(named: "starfilled")
            } else {
                favoritImage.image = UIImage(named: "starempty")
            }
            isFavorit = item.isfavorit
            
        }
    }
    
    
    
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        
        if pictureTitleTXT.text!.isEmpty {
            // no text in the text field
            let message = "No title entered"
            appDelegate.infoView(message: message, color: colorSmoothRed)
            
            pictureTitleTXT.attributedPlaceholder = NSAttributedString(string: "Title", attributes: [NSForegroundColorAttributeName: UIColor.red])
            
            
            
            
        } else {
            // there is text in the text field
            
            
            let newPicture = Picture.pictureIsExist(insertSecretName: pictureTitleTXT.text!, context: context)
            
            
            if newPicture == nil {
                // title not matched any other titles
                
                var item: Picture!
                
                
                if pictureToEdit != nil {
                    // edit mode
                    item = pictureToEdit
                    
                    
                } else {
                    // add new item
                    item = Picture(context: context)
                    item.lastusedate = NSDate()
                }
                item.image1 = pictureImage1LB.image
                item.image2 = pictureImage2LB.image
                item.name = pictureTitleTXT.text
                item.isfavorit = isFavorit
                let message = "Saved Successfully"
                appDelegate.infoView(message: message, color: colorLightGreen)
                ad.saveContext()
                navigationController?.popViewController(animated: true)
                
            } else {
                // title is matching other title
                
                if newPicture == pictureToEdit {
                    // same edit to item so it is okay to replace it
                    
                    pictureToEdit?.image1 = pictureImage1LB.image
                    pictureToEdit?.image2 = pictureImage2LB.image
                    pictureToEdit?.name = pictureTitleTXT.text
                    pictureToEdit?.isfavorit = isFavorit
                    let message = "Saved Successfully"
                    appDelegate.infoView(message: message, color: colorLightGreen)
                    ad.saveContext()
                    navigationController?.popViewController(animated: true)
                    
                    
                } else {
                    // title is matching other title but it cannot be replaced
                    
                    let message = "\(pictureTitleTXT.text!) is Exist"
                    appDelegate.infoView(message: message, color: colorSmoothRed)
                    
                    pictureTitleTXT.textColor = UIColor.red
                }
                
                
               
                
            }
            
        }
        
        
    }
    
    
    
    @IBAction func favoritBTPressed(_ sender: UIButton) {
        
        if isFavorit {
            favoritImage.image = UIImage(named: "starempty")
        } else {
            favoritImage.image = UIImage(named: "starfilled")
        }
        
        
        isFavorit = !isFavorit
        pictureToEdit?.isfavorit = isFavorit
        ad.saveContext()
    }

        
        
        
     
    
    
    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        
        
        let alert = UIAlertController(
            title: "",
            message: "Confirm Delete!",
            preferredStyle: UIAlertControllerStyle.alert
        )
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {
            (alert: UIAlertAction) -> Void in
            
            if self.pictureToEdit != nil {
            context.delete(self.pictureToEdit!)
            ad.saveContext()
            }
            self.navigationController?.popViewController(animated: true)
        })
        
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        
        alert.addAction(deleteAction)
        alert.addAction(cancel)
        self.navigationController?.present(alert, animated: true, completion: nil)
        
        

    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            if let imageData = image.jpeg(.lowest) {
                
                let finalimage = imageData.compressTo(0.5)
                if imagePicked == 0 {
                    pictureImage1LB.image = finalimage
                } else if imagePicked == 1 {
                    pictureImage2LB.image = finalimage
                }
                
            }
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
  
    func addGuestures() {
        // tab and long press guestures for pictureImage1LB
        let Image1LongPressGest = UILongPressGestureRecognizer(target: self, action: #selector(editImage))
        pictureImage1LB.addGestureRecognizer(Image1LongPressGest)
        
        let Image1TabGest = UITapGestureRecognizer(target: self, action: #selector(zoomImage))
        Image1TabGest.numberOfTapsRequired = 2
        pictureImage1LB.addGestureRecognizer(Image1TabGest)
        
        // tab and long press guestures for pictureImage2LB
        let Image2LongPressGest = UILongPressGestureRecognizer(target: self, action: #selector(editImage))
        pictureImage2LB.addGestureRecognizer(Image2LongPressGest)
        
        let Image2TabGest = UITapGestureRecognizer(target: self, action: #selector(zoomImage))
        Image2TabGest.numberOfTapsRequired = 2
        pictureImage2LB.addGestureRecognizer(Image2TabGest)
        
        
    }
    
   
    
    
    func zoomImage (_ sender: UITapGestureRecognizer) {
        
        if let view = sender.view as? UIImageView {
           
           performSegue(withIdentifier: "ShowZoomImageVC", sender: view)
            
        }
        
    }
   
    
    
    
    
    
    func editImage(_ sender: UITapGestureRecognizer) {
        print("2")
        
        
        if let view = sender.view as? UIImageView {
            imagePicked = view.tag
        }

        
        
        let alert = UIAlertController(
            title: "",
            message: "Select Camera or Photo library",
            preferredStyle: UIAlertControllerStyle.actionSheet
        )
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {
            (alert: UIAlertAction) -> Void in
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            self.afteralert()
        })
        let photolibraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: {
            (alert: UIAlertAction) -> Void in
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.afteralert()
        })
        let deleteAction = UIAlertAction(title: "Remove Picture", style: .destructive, handler: {
            (alert: UIAlertAction) -> Void in
            self.removeImage()
        })
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        
        alert.addAction(cameraAction)
        alert.addAction(photolibraryAction)
        alert.addAction(deleteAction)
        alert.addAction(cancel)
        self.navigationController?.present(alert, animated: true, completion: nil)
        
        
        
        
        
        
    }
    
    func removeImage () {
        
        if imagePicked == 0 {
            pictureImage1LB.image = UIImage(named: "imagePick")
        } else if imagePicked == 1 {
             pictureImage2LB.image = UIImage(named: "imagePick")
            
        }
        
    }
    
    func afteralert() {
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true, completion: nil)
    }
    
}
