//
//  LoginVC.swift
//  KeepSecret
//
//  Created by Michael Tanious on 4/12/17.
//  Copyright © 2017 winmacworldIOS. All rights reserved.
//

import UIKit

class LoginVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate {

    // UI Outlets
    
    @IBOutlet weak var pickerView1: UIPickerView!
    
    @IBOutlet weak var confirmPasswordView: UIStackView!
    
    @IBOutlet weak var loginOrCreatePasswordLB: UIButton!
    
    @IBOutlet weak var firstDigitLB: UITextField!
    @IBOutlet weak var secondDigitLB: UITextField!
    @IBOutlet weak var thirdDigitLB: UITextField!
    @IBOutlet weak var fourthDigitLB: UITextField!
    
    @IBOutlet weak var resetLB: UILabel!
    
    
    
    
    
    
    // Variable
    let sympols = ["0","1", "2" , "3" , "4" , "5" , "6" , "7" , "8" , "9" , "A" , "B" , "C" , "D" , "E", "F" , "G" , "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "!", "@", "#", "$", "%", "&", "*", "+", "-", "~"]
    var masterPassword: String?
    var confirmassword: String?
    var pickerPassword: String?
    
    var digit1 = "0"
    var digit2 = "0"
    var digit3 = "0"
    var digit4 = "0"
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView1.delegate = self
        pickerView1.dataSource = self
        
        self.hideKeyboardOnTap(#selector(self.dismissKeyboard))
        
        if let firstLog = UserDefaults.standard.value(forKey: "firstLog") as? String {
            
            print("Not First Launch")
            loginOrCreatePasswordLB.setTitle("Login", for: .normal)
            confirmPasswordView.isHidden = true
        } else {
            print(" First Launch")
            confirmPasswordView.isHidden = false
            loginOrCreatePasswordLB.setTitle("Create Password", for: .normal)
            
            
            
            
        }
      
        
        
        
        

        // Do any additional setup after loading the view.
    }

    
    // dismiss the keyboard
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    // remove the place holder when you touch the text field
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
    }
    
    
    // limit the textfield to 1 character for the password
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 1
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    
    // implement the password pickerview
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sympols.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sympols[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        let titleData = sympols[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName: UIFont(name: "Georgia", size: 26.0)!, NSForegroundColorAttributeName:UIColor.black])
     pickerLabel.attributedText = myTitle
        
        //color  and center the label's background
        let hue = CGFloat(row)/CGFloat(sympols.count)
        pickerLabel.backgroundColor = UIColor(hue: hue, saturation: 1.0, brightness:1.0, alpha: 1.0)
        pickerLabel.textAlignment = .center
        
        
        return pickerLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch component {
        case 0:
            digit1 = sympols[row]
            break
        case 1:
            digit2 = sympols[row]
            break
        case 2:
            digit3 = sympols[row]
            break
        case 3:
            digit4 = sympols[row]
            break
        default:
            break
        }
        
    }
    
    
    
    
    @IBAction func loginOrCreatePasswordBTPressed(_ sender: UIButton) {
        
        if sender.titleLabel?.text == "Login" {
            
            pickerPassword = digit1 + digit2 + digit3 + digit4
            if let firstLog = UserDefaults.standard.value(forKey: "firstLog") as? String {
                masterPassword = firstLog
            }
            if masterPassword == pickerPassword {
                let message = "Welcome"
                appDelegate.infoView(message: message, color: colorLightGreen)
                // Perform Segue to home vc ( CategoryVC )
                performSegue(withIdentifier: "ShowCategoryVC", sender: masterPassword)
                
                
            } else {
                
                let message = "Wrong Password!"
                appDelegate.infoView(message: message, color: colorSmoothRed)

                
//                resetLB.text = "Wrong Password!"
//                resetLB.textColor = UIColor.red
            }
            
            
            
        } else if sender.titleLabel?.text == "Create Password" {
            
            
            if firstDigitLB.text!.isEmpty || secondDigitLB.text!.isEmpty || thirdDigitLB.text!.isEmpty || fourthDigitLB.text!.isEmpty {
                let message = "Please Enter Four Digits"
                appDelegate.infoView(message: message, color: colorSmoothRed)
                
                firstDigitLB.attributedPlaceholder = NSAttributedString(string: "0", attributes: [NSForegroundColorAttributeName: UIColor.red])
                secondDigitLB.attributedPlaceholder = NSAttributedString(string: "0", attributes: [NSForegroundColorAttributeName: UIColor.red])
                thirdDigitLB.attributedPlaceholder = NSAttributedString(string: "0", attributes: [NSForegroundColorAttributeName: UIColor.red])
                fourthDigitLB.attributedPlaceholder = NSAttributedString(string: "0", attributes: [NSForegroundColorAttributeName: UIColor.red])                
                
                
            } else {
            
            confirmassword = firstDigitLB.text! + secondDigitLB.text! + thirdDigitLB.text! + fourthDigitLB.text!
            pickerPassword = digit1 + digit2 + digit3 + digit4
           
            
            
            if confirmassword! == pickerPassword! {
                
                
                // save password to userdefaults 
                UserDefaults.standard.set(confirmassword, forKey: "firstLog")
                
                // Perform Segue to home vc ( CategoryVC )
                performSegue(withIdentifier: "ShowCategoryVC", sender: masterPassword)
            } else {
                // Information message
                let message = "Digits not Match!"
                appDelegate.infoView(message: message, color: colorSmoothRed)
                firstDigitLB.textColor = UIColor.red
                secondDigitLB.textColor = UIColor.red
                thirdDigitLB.textColor = UIColor.red
                fourthDigitLB.textColor = UIColor.red
                
                
                }
            
            }
            
            
            
            
        }
        
        
    }
    
    
    
}









