//
//  ReadRecipes
//  textToTableViewController
//
//  Created by Priya Xavier on 10/3/16.
//  Copyright © 2016 Guild/SA. All rights reserved.
//

import UIKit
import AVFoundation

class ReadRecipesController: UIViewController, UITableViewDelegate, UITableViewDataSource,AVSpeechSynthesizerDelegate {

    var recipeToLoad: RecipeData?
    
    @IBOutlet weak var saveBtn: UIButton!
   
    struct myRecipeStruct {
        var recipeName: String?
        var recipePart: RecipePart
    }
    
    enum RecipePart {
        case title
        case ingredients
        case instructions
    }
    var myRecipeStructArray = [myRecipeStruct]()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var synthesizer = AVSpeechSynthesizer()
    
    @IBOutlet weak var startReading: UIButton!
    @IBOutlet weak var pauseReading: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Convert recipe data from a RecipeData Object to an array of myRecipeStruct type data
        
        if let recipe = recipeToLoad {
            if let title = recipe.title {
  
                myRecipeStructArray.append(myRecipeStruct(recipeName: title, recipePart: RecipePart.title))
            }
            if let ingredients = recipe.ingredients {

                for i in ingredients {
 
                myRecipeStructArray.append(myRecipeStruct(recipeName: i, recipePart: RecipePart.ingredients))
                }
            
            }
            if let instructions = recipe.instructions {
                for i in instructions {
                    //Check if string in empty
                    if !i.isEmpty  {
  //                      myRecipeArray.append("\(i).")
                        myRecipeStructArray.append(myRecipeStruct(recipeName: i, recipePart: RecipePart.instructions))
                    }
                }
            }
            
        }
        
        //Make resizable cell width
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
    
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Action Buttons
    @IBAction func startReading(_ sender: UIButton) {
        if synthesizer.isPaused {
        
        synthesizer.continueSpeaking()
        
        } else {
            for recipeStruct in myRecipeStructArray {
            print(recipeStruct.recipeName!)
        callSpeechSynthesizer(step: recipeStruct.recipeName!) //TODO how to make this an optional call
        }
        }
    }

    @IBAction func pauseReading(_ sender: UIButton) {
        if synthesizer.isSpeaking {
            synthesizer.pauseSpeaking(at: AVSpeechBoundary.word)
            print("Is PAUSED")
        }
    
        
        
    }
    
    @IBAction func stopReading(_ sender: UIButton) {
        
        synthesizer.stopSpeaking(at: AVSpeechBoundary.word)     }
    
    @IBAction func editRecipe(_ sender: UIButton) {
 //       print("TableView Section = \(tableView.numberOfRows(inSection: 0))")
//        for j in 0...tableView.numberOfRows(inSection: 0) - 1
//        {
//            print(j)
//            let cell = tableView.cellForRow(at: IndexPath(row: j, section: 0)) as! RecipeTableViewCell
//            cell.myTextField.isEnabled = true
//            
//        }
        print("Number of visible cells = \(tableView.visibleCells.count)")
        for j in 0...tableView.visibleCells.count - 1 {
        print("Count j = \(j)")
        let cell = tableView.visibleCells[j] as! RecipeTableViewCell
            cell.myTextField.isEnabled = true
            
        }
    
    }
    
    
    @IBAction func backBtn(_ sender: UIButton) {
        navigationController!.popViewController(animated: true)
    }
    //Speech Synthesizer
    func callSpeechSynthesizer(step: String) {
        
        let utterance = AVSpeechUtterance(string: step)
        print(utterance)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        
   // print(utterance.voice?.language)
        
        do{
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            
            do{
                try AVAudioSession.sharedInstance().setActive(true)
            }catch{
                
            }
        }catch{
            
        }
        
        synthesizer.speak(utterance)
     
        
    }
    @IBAction func saveBtn(_ sender: UIButton) {
        
        saveBtn.isEnabled = false
        var titleToSave = String()
        var ingredientsToSave = [String]()
        var instructionsToSave = [String]()
        
        print("TableView Section = \(tableView.numberOfRows(inSection: 0))")
        
        for i in myRecipeStructArray {
            switch i.recipePart {
            case .title: if let t = i.recipeName {
                                    titleToSave = t
                                 print(t)
                                }
            case .ingredients : if let r = i.recipeName {
                                ingredientsToSave.append(r)
                                print(r) }
                
                
            case .instructions: if let s = i.recipeName {
                                instructionsToSave.append(s)
                                print(s) }
                
            }
        }
        
        
      
        recipeToLoad?.title = titleToSave
        recipeToLoad?.ingredients = ingredientsToSave
        recipeToLoad?.instructions = instructionsToSave
        print(" \(recipeToLoad?.title)")
        print("\(recipeToLoad?.ingredients)")
        print("\(recipeToLoad?.instructions)")
        BackendlessManager.sharedInstance.saveRecipe(recipeData: recipeToLoad!,
        completion: {
            self.saveBtn.isEnabled = true
            print("Segue to Table of Saved Recipes after data is saved in BE")
             self.performSegue(withIdentifier: "unwindToSavedRecipes", sender: self)
            
            }, error: {
                // It was NOT saved to the database! - tell the user and DON'T call performSegue.
                let alertController = UIAlertController(title: "Save Error",
                                                        message: "Oops! We couldn't save your Recipe at this time.",
                                                        preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion: nil)
                
                self.saveBtn.isEnabled = true

        })
    }
    // From UITableViewDataSource protocol.
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    // From UITableViewDataSource protocol.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myRecipeStructArray.count
    }
    
    // From UITableViewDataSource protocol.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeTableViewCell", for: indexPath) as! RecipeTableViewCell
        
        cell.myTextField.text = myRecipeStructArray[(indexPath as IndexPath).row].recipeName
        print("Row Number = \((indexPath as IndexPath).row)")
        cell.myTextField.isEnabled = false
        return cell
    }
    
    // From UITableViewDelegate protocol.
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    // From UITableViewDelegate protocol.
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor = UIColor.red
    }
    
    // From UITableViewDelegate protocol.
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor = UIColor.clear
    }
    
    // From UITableViewDelegate protocol.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor = UIColor.gray
            }
    
   
    
}

