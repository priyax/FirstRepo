//
//  RegisterViewController.swift
//  textToTableViewController
//
//  Created by Priya Xavier on 10/6/16.
//  Copyright © 2016 Guild/SA. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
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
        self.emailFieldReg.delegate = self
        self.passwordFieldReg.delegate = self
        self.confirmPasswordField.delegate = self 
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  //facebook and twitter login
  @IBAction func loginViaFacebook(_ sender: UIButton) {
    BackendlessManager.sharedInstance.loginViaFacebook(completion: {
      
    }, error: { message in
      Utility.showAlert(viewController: self, title: "Login Error", message: message)
      
    })
  }
  
  @IBAction func loginViaTwitter(_ sender: UIButton) {
    BackendlessManager.sharedInstance.loginViaTwitter(completion: {
      
    }, error: { message in
      Utility.showAlert(viewController: self, title: "Login Error", message: message)
      
    })
  }
    //Hide Keyboard when user touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //Presses return key to exit keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return (true)
    }

    func textFieldChanged(textField: UITextField) {
        if emailFieldReg.text == "" || passwordFieldReg.text == "" || confirmPasswordField.text == "" {
            regBtn.isEnabled = false
        } else {
            regBtn.isEnabled = true
        }
    }
    // UITextFieldDelegate, called when editing session begins, or when keyboard displayed
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        // Create padding for textFields
        let paddingView = UIView(frame:CGRect(x: 0, y: 0, width: 20, height: 20))
        
        textField.leftView = paddingView
        textField.leftViewMode = UITextFieldViewMode.always
        
        if textField == emailFieldReg {
            emailFieldReg.placeholder = "Email"
        } else if textField == passwordFieldReg {
            passwordFieldReg.placeholder = "Password"
        } else {
            confirmPasswordField.placeholder = "Confirm password"}
    }

    
}
