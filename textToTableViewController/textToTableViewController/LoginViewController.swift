//
//  LoginViewController.swift
//  textToTableViewController
//
//  Created by Priya Xavier on 10/6/16.
//  Copyright © 2016 Guild/SA. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
  
    @IBAction func cancelBtn(_ sender: UIButton) {
    }
    @IBOutlet weak var signInBtn: UIButton!
    @IBAction func signIn(_ sender: UIButton) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.addTarget(self, action: #selector(textFieldChanged(textField:)), for: UIControlEvents.editingChanged)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldChanged(textField: UITextField) {
        
        if emailField.text == "" || passwordField.text == "" {
            signInBtn.isEnabled = false
        } else {
            signInBtn.isEnabled = true
        }
    }
    
}
