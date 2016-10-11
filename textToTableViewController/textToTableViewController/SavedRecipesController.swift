//
//  SavedRecipesController.swift
//  textToTableViewController
//
//  Created by Priya Xavier on 10/6/16.
//  Copyright © 2016 Guild/SA. All rights reserved.
//

import UIKit

class SavedRecipesController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//Alert view to navigate to website or manual input of recipe
    
    @IBAction func addRecipe(_ sender: UIButton) {
        
        //
        // UIAlertController - Action Sheet
        //
        // https://developer.apple.com/ios/human-interface-guidelines/ui-views/action-sheets/
        //
        
        let alertController = UIAlertController(title: nil,
                                                message: "Get your recipe on the clipboard",
                                                preferredStyle: .actionSheet)
        
        let extractFromWeb = UIAlertAction(title: "Recipe from Web", style: .default) { action in
            self.performSegue(withIdentifier: "gotoExtractRecipe", sender: self)
            print("Save was selected!")
        }
        
        alertController.addAction(extractFromWeb)
        
        let manualEntry = UIAlertAction(title: "Recipe from typing", style: .destructive) { action in
            print("Discard was selected!")
        }
        
        alertController.addAction(manualEntry)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            print("Cancel was selected!")
        }
        
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true) {
            print("Show the Action Sheet!")
        }
    }


}
