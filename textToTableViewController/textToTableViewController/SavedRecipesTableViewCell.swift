//
//  SavedRecipesTableViewCell.swift
//  textToTableViewController
//
//  Created by Priya Xavier on 10/24/16.
//  Copyright © 2016 Guild/SA. All rights reserved.
//

import UIKit

class SavedRecipesTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    @IBOutlet weak var recipePic: UIImageView!
    @IBOutlet weak var RecipeTitle: UILabel!
  //  @IBOutlet weak var recipeUrl: UILabel!
}
