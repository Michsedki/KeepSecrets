//
//  WebViewVC.swift
//  KeepSecret
//
//  Created by Michael Tanious on 4/12/17.
//  Copyright © 2017 winmacworldIOS. All rights reserved.
//

import UIKit

class WebViewVC: UIViewController , UITextFieldDelegate  {

    
    
    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var URLText: UITextField!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        URLText.delegate = self
        self.hideKeyboardOnTap(#selector(self.dismissKeyboard))
        
        let defaultURL = "https://www.google.com/"
        webView.loadRequest(URLRequest(url: URL(string: defaultURL)!))
        

        // Do any additional setup after loading the view.
    }

    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // remove the place holder when you touch the text field
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
    }
    
    
    
    
    @IBAction func goBTPressed(_ sender: UIButton) {
        
        
       
        if URLText.text!.isEmpty {
             URLText.attributedPlaceholder = NSAttributedString(string: "Web URL", attributes: [NSForegroundColorAttributeName: UIColor.red])
            
        } else {
            webView.loadRequest(URLRequest(url: URL(string: URLText.text!)!))
        }
        
    }

}










