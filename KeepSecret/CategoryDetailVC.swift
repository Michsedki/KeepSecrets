//
//  CategoryDetailVC.swift
//  KeepSecret
//
//  Created by Michael Tanious on 4/10/17.
//  Copyright © 2017 winmacworldIOS. All rights reserved.
//

import UIKit

class CategoryDetailVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate , UIScrollViewDelegate {
    
    // UI IBOutlet
    @IBOutlet weak var detailCategoryImage: UIImageView!
    @IBOutlet weak var detailCategoryNameText: CustomTextField!
    @IBOutlet weak var detailCategoryDetailText: UITextView!
   
    
    
    
    
    // Variables
    var categoryToEdit: Category?
    var imagePicker: UIImagePickerController!
    var alert = UIAlertController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGuestures()
        
        
        if categoryToEdit != nil {
            self.title = "Edit Category"
            
            loadCategoryData()
            
            
        } else {
            self.title = "Add Category"
        }
        
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        self.hideKeyboardOnTap(#selector(self.dismissKeyboard))
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        
        
        
        
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
    
    
    func loadCategoryData() {
        if let item = categoryToEdit {
            detailCategoryImage.image = item.image as? UIImage
            detailCategoryNameText.text = item.name
            detailCategoryDetailText.text = item.details
        }
    }
    
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        
        if detailCategoryNameText.text!.isEmpty {
            // no text in the text field
            let message = "No title entered"
            appDelegate.infoView(message: message, color: colorSmoothRed)
            
            detailCategoryNameText.attributedPlaceholder = NSAttributedString(string: "Title", attributes: [NSForegroundColorAttributeName: UIColor.red])
            
            
            
            
        } else {
            // there is text in the text field
            
            
            let newCategory = Category.categoryIsExist(insertSecretName: detailCategoryNameText.text!, context: context)
            
            if newCategory == nil {
                // title not matched any other titles
                
                var item: Category!
                
                
                if categoryToEdit != nil {
                    // edit mode
                    item = categoryToEdit
                    
                    
                } else {
                    // add new item
                    item = Category(context: context)
                    item.lastusedate = NSDate()
                }
                
                if let title = detailCategoryNameText.text {
                    item.name = title
                }
                if let image = detailCategoryImage.image {
                    item.image = image
                }
                let message = "Saved Successfully"
                appDelegate.infoView(message: message, color: colorLightGreen)
                ad.saveContext()
                navigationController?.popViewController(animated: true)
                
            } else {
                // title is matching other title
                
                if newCategory == categoryToEdit {
                    // same edit to item so it is okay to replace it
                    
                    if let title = detailCategoryNameText.text {
                        categoryToEdit?.name = title
                    }
                    if let image = detailCategoryImage.image {
                        categoryToEdit?.image = image
                    }
                    
                   
                    let message = "Saved Successfully"
                    appDelegate.infoView(message: message, color: colorLightGreen)
                    ad.saveContext()
                    
                    
                    
                    navigationController?.popViewController(animated: true)
                    
                    
                } else {
                    // title is matching other title but it cannot be replaced
                    
                    let message = "\(detailCategoryNameText.text!) is Exist"
                    appDelegate.infoView(message: message, color: colorSmoothRed)
                    
                    detailCategoryNameText.textColor = UIColor.red
                }
                
                
                
                
            }
            
        }

        
    }
    
    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        
         alert = UIAlertController(
            title: "",
            message: "Confirm Delete!",
            preferredStyle: UIAlertControllerStyle.alert
        )
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {
            (alert: UIAlertAction) -> Void in
            
            if self.categoryToEdit != nil {
                context.delete(self.categoryToEdit!)
                ad.saveContext()
                self.alert.dismiss(animated: true, completion: nil)
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
            detailCategoryImage.image = image
            
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    
    func addGuestures() {
        // tab and long press guestures for pictureImage1LB
        let Image1LongPressGest = UILongPressGestureRecognizer(target: self, action: #selector(editImage))
        detailCategoryImage.addGestureRecognizer(Image1LongPressGest)
        
        let Image1TabGest = UITapGestureRecognizer(target: self, action: #selector(zoomImage))
        Image1TabGest.numberOfTapsRequired = 2
        detailCategoryImage.addGestureRecognizer(Image1TabGest)
        
        
    }
    
   
    func zoomImage (_ sender: UITapGestureRecognizer) {
        
        if let view = sender.view as? UIImageView {
            performSegue(withIdentifier: "ShowZoomImageVC", sender: view)
            

            
        }
    }
    
 
    func editImage(_ sender: UITapGestureRecognizer) {
        
         alert = UIAlertController(
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
            self.detailCategoryImage.image = UIImage(named: "imagePick")
            
        })
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        
        alert.addAction(cameraAction)
        alert.addAction(photolibraryAction)
        alert.addAction(deleteAction)
        alert.addAction(cancel)
        
        
        self.navigationController?.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    func afteralert() {
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true, completion: nil)
        alert.dismiss(animated: true, completion: nil)
    }

    
    
    
    
    
}
