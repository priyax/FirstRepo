//
//  SavedRecipesController.swift
//  textToTableViewController
//
//  Created by Priya Xavier on 10/6/16.
//  Copyright © 2016 Guild/SA. All rights reserved.
//

import UIKit

class SavedRecipesController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    //MARK: Properties
    
    @IBOutlet weak var tableView: UITableView!
    var recipes = [RecipeData]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BackendlessManager.sharedInstance.loadRecipes {recipesData in
        self.recipes += recipesData
            self.tableView.reloadData()}
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
    
    
    ///////
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "savedRecipesCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SavedRecipesTableViewCell
        
        // Fetches the appropriate meal for the data source layout.
        let recipe = recipes[(indexPath as NSIndexPath).row]
        
        cell.RecipeTitle.text = recipe.title
       // cell.recipeUrl.text = recipe.recipeUrl
        
        cell.recipePic.image = nil
        
        print("recipe tmage!!! \(recipe.thumbnailUrl )")
        if let thumbnailUrl = recipe.thumbnailUrl {
            if thumbnailUrl != "" {
            loadImageFromUrl(cell: cell, thumbnailUrl: thumbnailUrl)
            }
            
        }
     
        
        return cell
    }
    
    
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "gotoReadRecipesFromTableVC" {
            
            let readRecipesTableViewController = segue.destination as! ReadRecipesController
            
            // Get the cell that generated this segue.
            if let selectedRecipesCell = sender as? SavedRecipesTableViewCell {
                
                let indexPath = tableView.indexPath(for: selectedRecipesCell)!
                let selectedRecipe = recipes[(indexPath as NSIndexPath).row]
                readRecipesTableViewController.recipeToLoad = selectedRecipe
                print("Its coming here!!! \(selectedRecipe.title)")
            }
            
        }
    }

    
    
///////////
    
    func loadImageFromUrl(cell: SavedRecipesTableViewCell, thumbnailUrl: String)  {
    let url = URL(string: thumbnailUrl)
        print("URL!!!!!\(url)")
        let session = URLSession.shared
        let task = session.dataTask(with: url!, completionHandler: { (data,response,error) in
            if error == nil {
                do {
                
                let data = try Data(contentsOf: url!, options: [])
                    DispatchQueue.main.sync {
                        cell.recipePic.image = UIImage(data: data)
                        
                    }
                }catch
                { print("NSData Error \(error)")
                }
                
            } else { print("NSURLSession error: \(error)")
            }
             })
        task.resume()
    }
    
    

    @IBAction func unwindToSavedRecipes(_ sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ReadRecipesController, let recipe = sourceViewController.recipeToLoad {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                
                // Update an existing meal.
                recipes[(selectedIndexPath as NSIndexPath).row] = recipe
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
                
            } else {
                
                // Add a new meal.
                let newIndexPath = IndexPath(row: recipes.count, section: 0)
                recipes.append(recipe)
                tableView.insertRows(at: [newIndexPath], with: .bottom)
            }
            
        
        }
        
    
    }
}
