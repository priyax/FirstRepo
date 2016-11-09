//
//  myCell.swift
//  textToTableViewController
//
//  Created by Priya Xavier on 10/3/16.
//  Copyright © 2016 Guild/SA. All rights reserved.
//

import UIKit

class RecipeTableViewCell: UITableViewCell, UITextViewDelegate {

    var index: Int?
    
 //   @IBOutlet weak var myTextField: UITextField!
   
    @IBOutlet weak var recipeTextView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

   
    
    
    
}
