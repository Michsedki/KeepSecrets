//
//  SecretDetailVC.swift
//  KeepSecret
//
//  Created by Michael Tanious on 4/10/17.
//  Copyright © 2017 winmacworldIOS. All rights reserved.
//

import UIKit
import CoreData

class SecretDetailVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate , UIScrollViewDelegate {
    
    // UI Outlet
    
    @IBOutlet weak var categoryImageLB: UIImageView!
    @IBOutlet weak var categoryTitleLB: UILabel!
    @IBOutlet weak var secretImage1LB: UIImageView!
    @IBOutlet weak var secretImage2LB: UIImageView!
    @IBOutlet weak var secretTitleLB: UITextField!
    @IBOutlet weak var secretEmailLB: UITextField!
    @IBOutlet weak var secretAccountNumberLB: UITextField!
    @IBOutlet weak var secretWebSiteLB: UITextField!
    @IBOutlet weak var secretUserNameLB: UITextField!
    @IBOutlet weak var secretPassword1LB: UITextField!
    @IBOutlet weak var secretPassword2LB: UITextField!
    @IBOutlet weak var secretNickName: UITextField!
    @IBOutlet weak var secretPhoneNumber: UITextField!
    @IBOutlet weak var secretZipCodeLB: UITextField!
    @IBOutlet weak var secretPinNumberLB: UITextField!
    @IBOutlet weak var secretSecurityQuestionLB: UITextField!
    @IBOutlet weak var secretQuestionAnswerLB: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var favoritImageLB: UIImageView!
    

    
    
    
    
    var categoryToSaveIn: Category?
    var secretToEdit: Secret?
    var imagePicker: UIImagePickerController!
    var imagePicked = 0
    var isFavorit = false
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryImageLB.image = categoryToSaveIn?.image as? UIImage
        categoryTitleLB.text = categoryToSaveIn?.name
        
        if secretToEdit != nil {
            self.title = "Edit Secret"
            loadSecretData()
        } else {
            self.title = "Add Secret"
        }
        
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        self.hideKeyboardOnTap(#selector(self.dismissKeyboard))
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        
        
        addGuestures()
        
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func loadSecretData() {
        if let item = secretToEdit {
            categoryImageLB.image = item.toCategory?.image as? UIImage
            categoryTitleLB.text = item.toCategory?.name
            secretTitleLB.text = item.name
            secretEmailLB.text = item.email
            secretAccountNumberLB.text = item.accountnumber
            secretWebSiteLB.text = item.website
            secretUserNameLB.text = item.username
            secretPassword1LB.text = item.password1
            secretPassword2LB.text = item.password2
            secretNickName.text = item.nickname
            secretPhoneNumber.text = item.phonenumber
            secretZipCodeLB.text = item.zipcode
            secretPinNumberLB.text = item.pinnumber
            secretSecurityQuestionLB.text = item.securityquestion
            secretQuestionAnswerLB.text = item.questionanswer
            secretImage1LB.image = item.image1 as? UIImage
            secretImage2LB.image = item.image2 as? UIImage
            if item.isfavorit {
                favoritImageLB.image = UIImage(named: "starfilled")
            } else {
                favoritImageLB.image = UIImage(named: "starempty")
            }
            isFavorit = item.isfavorit
            
            
            
            
        }
        
    }
    
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        
        
        if secretTitleLB.text!.isEmpty {
            // no text in the text field
            let message = "No title entered"
            appDelegate.infoView(message: message, color: colorSmoothRed)
            
            secretTitleLB.attributedPlaceholder = NSAttributedString(string: "Title", attributes: [NSForegroundColorAttributeName: UIColor.red])
            
            
            
            
        } else {
            // there is text in the text field
            
            
            let newSecret = Secret.secretIsExist(insertSecretName: secretTitleLB.text!, context: context)
            
            
            if newSecret == nil {
                // title not matched any other titles
                
                var item: Secret!
                
                
                if secretToEdit != nil {
                    // edit mode
                    item = secretToEdit
                    
                    
                } else {
                    // add new item
                    item = Secret(context: context)
                    item.toCategory = categoryToSaveIn
                    item.lastusedate = NSDate()
                    
                }
                if let title = secretTitleLB.text {
                    item.name = title
                }
                if let email = secretEmailLB.text {
                    item.email = email
                }
                if let accountnumber = secretAccountNumberLB.text {
                    item.accountnumber = accountnumber
                }
                if let website = secretWebSiteLB.text {
                    item.website = website
                }
                if let username = secretUserNameLB.text {
                    item.username = username
                }
                if let password1 = secretPassword1LB.text {
                    item.password1 = password1
                }
                if let password2 = secretPassword2LB.text {
                    item.password2 = password2
                }
                if let nickname = secretNickName.text {
                    item.nickname = nickname
                }
                
                if let phonenumber = secretPhoneNumber.text {
                    item.phonenumber = phonenumber
                }
                if let zipcode = secretZipCodeLB.text {
                    item.zipcode = zipcode
                }
                if let pinnumber = secretPinNumberLB.text {
                    item.pinnumber = pinnumber
                }
                if let securityquestion = secretSecurityQuestionLB.text {
                    item.securityquestion = securityquestion
                }
                if let questionanswer = secretQuestionAnswerLB.text {
                    item.questionanswer = questionanswer
                }
                if let image1 = secretImage1LB.image {
                    item.image1 = image1
                }
                if let image2 = secretImage2LB.image {
                    item.image2 = image2
                }
                
                item.isfavorit = isFavorit
                let message = "Saved Successfully"
                appDelegate.infoView(message: message, color: colorLightGreen)
                ad.saveContext()
                navigationController?.popViewController(animated: true)
                
            } else {
                // title is matching other title
                
                if newSecret == secretToEdit {
                    // same edit to item so it is okay to replace it
                    
                  
                    if let title = secretTitleLB.text {
                        secretToEdit?.name = title
                    }
                    if let email = secretEmailLB.text {
                        secretToEdit?.email = email
                    }
                    if let accountnumber = secretAccountNumberLB.text {
                        secretToEdit?.accountnumber = accountnumber
                    }
                    if let website = secretWebSiteLB.text {
                        secretToEdit?.website = website
                    }
                    if let username = secretUserNameLB.text {
                        secretToEdit?.username = username
                    }
                    if let password1 = secretPassword1LB.text {
                        secretToEdit?.password1 = password1
                    }
                    if let password2 = secretPassword2LB.text {
                        secretToEdit?.password2 = password2
                    }
                    if let nickname = secretNickName.text {
                        secretToEdit?.nickname = nickname
                    }
                    
                    if let phonenumber = secretPhoneNumber.text {
                        secretToEdit?.phonenumber = phonenumber
                    }
                    if let zipcode = secretZipCodeLB.text {
                        secretToEdit?.zipcode = zipcode
                    }
                    if let pinnumber = secretPinNumberLB.text {
                        secretToEdit?.pinnumber = pinnumber
                    }
                    if let securityquestion = secretSecurityQuestionLB.text {
                        secretToEdit?.securityquestion = securityquestion
                    }
                    if let questionanswer = secretQuestionAnswerLB.text {
                        secretToEdit?.questionanswer = questionanswer
                    }
                    if let image1 = secretImage1LB.image {
                        secretToEdit?.image1 = image1
                    }
                    if let image2 = secretImage2LB.image {
                        secretToEdit?.image2 = image2
                    }
                    
                    secretToEdit?.isfavorit = isFavorit
                    let message = "Saved Successfully"
                    appDelegate.infoView(message: message, color: colorLightGreen)
                    ad.saveContext()
                    navigationController?.popViewController(animated: true)
                    
                    
                } else {
                    // title is matching other title but it cannot be replaced
                    
                    let message = "\(secretTitleLB.text!) is Exist"
                    appDelegate.infoView(message: message, color: colorSmoothRed)
                    
                    secretTitleLB.textColor = UIColor.red
                }
                
                
            }
            
        }
        

        
    }
    
    
    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        
        
        let alert = UIAlertController(
            title: "",
            message: "Confirm Delete!",
            preferredStyle: UIAlertControllerStyle.alert
        )
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {
            (alert: UIAlertAction) -> Void in
            
            if self.secretToEdit != nil {
                context.delete(self.secretToEdit!)
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
            
            if imagePicked == 0 {
                secretImage1LB.image = image
            } else if imagePicked == 1 {
                secretImage2LB.image = image
            }
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
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
    
        
    @IBAction func favoritPressed(_ sender: UIButton) {
        if isFavorit {
            
            
            favoritImageLB.image = UIImage(named: "starempty")
        } else {
            favoritImageLB.image = UIImage(named: "starfilled")
        }
        
        
        isFavorit = !isFavorit
        secretToEdit?.isfavorit = isFavorit
        ad.saveContext()
    }
    
    
    
    
    func addGuestures() {
        // tab and long press guestures for pictureImage1LB
        let Image1LongPressGest = UILongPressGestureRecognizer(target: self, action: #selector(editImage))
        secretImage1LB.addGestureRecognizer(Image1LongPressGest)
        
        let Image1TabGest = UITapGestureRecognizer(target: self, action: #selector(zoomImage))
        Image1TabGest.numberOfTapsRequired = 2
        secretImage1LB.addGestureRecognizer(Image1TabGest)
        
        // tab and long press guestures for pictureImage2LB
        let Image2LongPressGest = UILongPressGestureRecognizer(target: self, action: #selector(editImage))
        secretImage2LB.addGestureRecognizer(Image2LongPressGest)
        
        let Image2TabGest = UITapGestureRecognizer(target: self, action: #selector(zoomImage))
        Image2TabGest.numberOfTapsRequired = 2
        secretImage2LB.addGestureRecognizer(Image2TabGest)
        
        
    }
    
   
    
    
    func zoomImage (_ sender: UITapGestureRecognizer) {
        
        if let view = sender.view as? UIImageView {
            
          performSegue(withIdentifier: "ShowZoomImageVC", sender: view)
            
        }     
        
    }
 
    
    func editImage(_ sender: UITapGestureRecognizer) {
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
    
    func afteralert() {
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    func removeImage () {
        
        if imagePicked == 0 {
            secretImage1LB.image = UIImage(named: "imagePick")
        } else if imagePicked == 1 {
            secretImage2LB.image = UIImage(named: "imagePick")
            
        }
        
    }


 
    
    
    
    

    
}
