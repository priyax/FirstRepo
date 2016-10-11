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
    @IBOutlet weak var regBtn: UIButton!
    @IBAction func register(_ sender: UIButton) {
        
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
