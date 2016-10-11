//
//  RegisterViewController.swift
//  textToTableViewController
//
//  Created by Priya Xavier on 10/6/16.
//  Copyright © 2016 Guild/SA. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailFieldReg: UITextField!
    
    @IBOutlet weak var passwordFieldReg: UITextField!
    
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBAction func cancelBtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var regBtn: UIButton!
    @IBAction func register(_ sender: UIButton) {
        if !Utility.isValidEmail(emailAddress: emailFieldReg.text!) {
            Utility.showAlert(viewController: self, title: "Registration Error", message: "Please enter a valid email address.")
            return
        }

        if passwordFieldReg.text != confirmPasswordField.text {
            Utility.showAlert(viewController: self, title: "Registration Error", message: "Password confirmation failed. Plase enter your password try again.")
            return
        }
        
        //spinner.startAnimating()
        
        let email = emailFieldReg.text!
        let password = passwordFieldReg.text!
        
        BackendlessManager.sharedInstance.registerUser(email: email, password: password,
            completion: {
                
                BackendlessManager.sharedInstance.loginUser(email: email, password: password,
                    completion: {
                    
                       // self.spinner.stopAnimating()
                        
                        self.performSegue(withIdentifier: "gotoSavedRecipesFromRegister", sender: sender)
                    },
                    
                    error: { message in
                        
                       // self.spinner.stopAnimating()
                        
                        Utility.showAlert(viewController: self, title: "Login Error", message: message)
                    })
            },
            
            error: { message in
                
             //   self.spinner.stopAnimating()
                
                Utility.showAlert(viewController: self, title: "Register Error", message: message)
            })
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailFieldReg.addTarget(self, action: #selector(textFieldChanged(textField:)), for: UIControlEvents.editingChanged)
        passwordFieldReg.addTarget(self, action: #selector(textFieldChanged(textField:)), for: UIControlEvents.editingChanged)
        confirmPasswordField.addTarget(self, action: #selector(textFieldChanged(textField:)), for: UIControlEvents.editingChanged)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldChanged(textField: UITextField) {
        if emailFieldReg.text == "" || passwordFieldReg.text == "" || confirmPasswordField.text == "" {
            regBtn.isEnabled = false
        } else {
            regBtn.isEnabled = true
        }
    }
    
    
}
