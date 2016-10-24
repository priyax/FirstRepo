//
//  myCell.swift
//  textToTableViewController
//
//  Created by Priya Xavier on 10/3/16.
//  Copyright © 2016 Guild/SA. All rights reserved.
//

import UIKit

class RecipeTableViewCell: UITableViewCell, UITextFieldDelegate {

   
    @IBOutlet weak var myTextField: UITextField!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
//    (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    [textField resignFirstResponder];
//    return NO;
//    }
    
    // Method gets called when the keyboard return key pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textFieldShouldReturn")
        
        myTextField.resignFirstResponder()
        //TODO Everytime sometime types into the text and hits return key the data has to be saved
        
        return true
    }
    
    
}
