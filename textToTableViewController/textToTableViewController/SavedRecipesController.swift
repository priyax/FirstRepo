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
  
  @IBOutlet weak var welcomeLabel: UILabel!
  
  @IBOutlet weak var notLoggedInLabel: UILabel!
  
  //  @IBOutlet weak var logOutBtn: UIButton!
  
  var recipes = [RecipeData]()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if (BackendlessManager.sharedInstance.isUserLoggedIn()){
      
      //force image to keep original color
      var logOutImage = UIImage(named: "logout")
      logOutImage = logOutImage!.withRenderingMode(.alwaysOriginal)
      navigationItem.leftBarButtonItem = UIBarButtonItem(image: logOutImage, style: .plain, target: self, action: #selector(logout(_:)))
      self.notLoggedInLabel.isHidden = true
      
      
      //// load archived recipedata object and save it to BE
      
      if let archivedRecipe = NSKeyedUnarchiver.unarchiveObject(withFile: RecipeData.ArchiverUrl.path) as? RecipeData {
        BackendlessManager.sharedInstance.saveRecipe(recipeData: archivedRecipe,
                                                     completion: {
                                                      //delete archived data
                                                      do {
                                                        try FileManager().removeItem(atPath: RecipeData.ArchiverUrl.path) }
                                                      catch {
                                                        print("No recipe stored in archiver")
                                                      }
                                                      
                                                      //load data that's in BE, including presaved recipes
                                                      BackendlessManager.sharedInstance.loadRecipes {recipesData in
                                                        self.recipes += recipesData
                                                        self.tableView.reloadData()
                                                        if self.recipes.count == 0
                                                        {
                                                          self.welcomeLabel.isHidden = false
                                                        } else {
                                                          self.welcomeLabel.isHidden = true
                                                        } }}, error: {
                                                          
                                                          let alertController = UIAlertController(title: "Save Error",
                                                                                                  message: "Oops! We couldn't save your recipe at this time.",
                                                                                                  preferredStyle: .alert)
                                                          
                                                          let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                                          alertController.addAction(okAction) })
        
        
      } else {
        BackendlessManager.sharedInstance.loadRecipes { recipesData in
          self.recipes += recipesData
          self.tableView.reloadData()
          if self.recipes.count == 0
          {
            self.welcomeLabel.isHidden = false
          } else {
            self.welcomeLabel.isHidden = true
          }
        }
      }
    }
    else {
      var backBtnImage = UIImage(named: "backBtn")
      backBtnImage = backBtnImage!.withRenderingMode(.alwaysOriginal)
      navigationItem.leftBarButtonItem = UIBarButtonItem(image: backBtnImage, style: .plain, target: self, action: #selector(backToLogin(_:)))
      self.notLoggedInLabel.isHidden = false
      self.welcomeLabel.isHidden = true
      //      self.logOutBtn.isEnabled = false
    }
    
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
      
    }
    
    alertController.addAction(extractFromWeb)
    
    let manualEntry = UIAlertAction(title: "Recipe By Typing", style: .default) { action in
      self.performSegue(withIdentifier: "gotoTypingRecipe", sender: self)
    }
    
    alertController.addAction(manualEntry)
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
    }
    
    alertController.addAction(cancelAction)
    
    //self.present(alertController, animated: true) {
    
    // }
    alertController.popoverPresentationController?.sourceView = self.view
    alertController.popoverPresentationController?.sourceRect = sender.bounds
    
    self.present(alertController, animated: true, completion: nil)
    
  }
  
  
  // @IBOutlet weak var searchBar: UISearchBar!
  
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
    
    cell.recipePic.image = nil
    
    cell.RecipeTitle.text = recipes[indexPath.row].title
    // Fetches the appropriate recipe for the data source layout.
    let recipe = recipes[(indexPath as NSIndexPath).row]
    if let thumbnailUrl = recipe.thumbnailUrl {
      if thumbnailUrl != "" {
        loadImageFromUrl(cell: cell, thumbnailUrl: thumbnailUrl)
      }
    }
    
    
    return cell
  }
  
  // Override to support editing the table view.
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    
    if editingStyle == .delete {
      
      
      // Find the Recipe Data in the data source that we wish to delete.
      let recipeToRemove = recipes[indexPath.row]
      
      BackendlessManager.sharedInstance.removeRecipe(recipeToRemove: recipeToRemove,
                                                     
                                                     completion: {
                                                      
                                                      // It was removed from the database, now delete the row from the data source.
                                                      self.recipes.remove(at: (indexPath as NSIndexPath).row)
                                                      tableView.deleteRows(at: [indexPath], with: .fade)
                                                      
                                                      if self.recipes.count == 0
                                                      {
                                                        self.welcomeLabel.isHidden = false
                                                      } else {
                                                        self.welcomeLabel.isHidden = true
                                                      }
      },
                                                     
                                                     error: {
                                                      
                                                      // It was NOT removed - tell the user and DON'T delete the row from the data source.
                                                      let alertController = UIAlertController(title: "Remove Failed",
                                                                                              message: "Oops! We couldn't remove your Recipe at this time.",
                                                                                              preferredStyle: .alert)
                                                      
                                                      let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                                      alertController.addAction(okAction)
                                                      
                                                      self.present(alertController, animated: true, completion: nil)
      }
      )
      
      
      
    }
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
        
      }
      
    }
  }
  
  
  func loadImageFromUrl(cell: SavedRecipesTableViewCell, thumbnailUrl: String)  {
    let url = URL(string: thumbnailUrl)
    
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
        
      } else { print("NSURLSession error: \(String(describing: error))")
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
        self.welcomeLabel.isHidden = true
      }
      
      
    }
    
    
  }
  
  
  //LogOut
  
  
  func logout(_ sender: UIButton) {
    
    let alertController = UIAlertController(title: nil,
                                            message: "Are you sure you want to log out?",
                                            preferredStyle: .actionSheet)
    let logOutApp = UIAlertAction(title: "Log Out", style: .default) { action in
      BackendlessManager.sharedInstance.logoutUser(
        completion: {
          
          //add segue programatically
          self.performSegue(withIdentifier: "gotoLoginFromSavedRecipes", sender: sender)
      },
        
        error: { message in
          
          
          Utility.showAlert(viewController: self, title: "Logout Error", message: message)
      })
      
    }
    
    alertController.addAction(logOutApp)
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
    }
    
    alertController.addAction(cancelAction)
    
    //self.present(alertController, animated: true) {
    
    // }
    alertController.popoverPresentationController?.sourceView = self.view
    alertController.popoverPresentationController?.sourceRect = sender.bounds
    
    self.present(alertController, animated: true, completion: nil)
    
    
  }
  
  func backToLogin(_ sender: UIButton){
    self.performSegue(withIdentifier: "gotoLoginFromSavedRecipes", sender: sender)
  }
  
}


