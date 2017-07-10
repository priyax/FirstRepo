//
//  ReadRecipes
//  textToTableViewController
//
//  Created by Priya Xavier on 10/3/16.
//  Copyright © 2016 Guild/SA. All rights reserved.
//

import UIKit
import AVFoundation

class ReadRecipesController: UIViewController, UITableViewDelegate, UITableViewDataSource,AVSpeechSynthesizerDelegate, UITextViewDelegate {

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
    var recipeArrayFromSelectedRow = [myRecipeStruct]()
    var startReadingIndex = 0
    var rowIsSelected = false
    
    @IBOutlet weak var tableView: UITableView!
    
    var synthesizer = AVSpeechSynthesizer()
    
    @IBOutlet weak var startReading: UIButton!
    @IBOutlet weak var pauseReading: UIButton!
    
    
    @IBOutlet weak var editBtn: UIButton!
    
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
        tableView.estimatedRowHeight = 70
    
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Action Buttons
    @IBAction func startReading(_ sender: UIButton) {
        if synthesizer.isPaused == true && rowIsSelected == false {
            // start reading after being paused
        synthesizer.continueSpeaking()
        }
        else if rowIsSelected == true {
        // start reading from selected row whether synthesiser was paused or not
            for recipeStruct in myRecipeStructArray[startReadingIndex...myRecipeStructArray.count - 1 ] {
                callSpeechSynthesizer(step: recipeStruct.recipeName!)
                rowIsSelected = false
            }
        } else {
        //start reading from beginning
        
            for recipeStruct in myRecipeStructArray {
                callSpeechSynthesizer(step: recipeStruct.recipeName!)
            }
        
        }
    }

    @IBAction func pauseReading(_ sender: UIButton) {
        if synthesizer.isSpeaking {
            synthesizer.pauseSpeaking(at: AVSpeechBoundary.immediate)
         // print("Is PAUSED")
        }
    
        
        
    }
    
    @IBAction func stopReading(_ sender: UIButton) {
        
        synthesizer.stopSpeaking(at: AVSpeechBoundary.word)
        startReadingIndex = 0
        rowIsSelected = false
    }
    
    
    @IBAction func editRecipe(_ sender: UIButton) {
       
        editBtn.isEnabled = false
        
      //print("Number of visible cells = \(tableView.visibleCells.count)")
        for j in 0...tableView.visibleCells.count - 1 {
     //   print("Count j = \(j)")
        let cell = tableView.visibleCells[j] as! RecipeTableViewCell
            cell.recipeTextView.isUserInteractionEnabled = true
           // cell.recipeTextView.isEditable = true
        }
    
    }
    
    
    @IBAction func backBtn(_ sender: UIButton) {
        synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
        navigationController!.popViewController(animated: true)
    }
    
    //Speech Synthesizer
    func callSpeechSynthesizer(step: String) {
        
        let utterance = AVSpeechUtterance(string: step)
  //      print(utterance)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.45
        utterance.pitchMultiplier = 1
        
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
      
      
      
        var titleToSave = String()
        var ingredientsToSave = [String]()
        var instructionsToSave = [String]()
        
  //      print("TableView Section = \(tableView.numberOfRows(inSection: 0))")
        
        for i in myRecipeStructArray {
            switch i.recipePart {
            case .title: if let t = i.recipeName {
                                    titleToSave = t
                                // print(t)
                                }
            case .ingredients : if let r = i.recipeName {
                                ingredientsToSave.append(r)
                               // print(r) 
                                }
                
                
            case .instructions: if let s = i.recipeName {
                                instructionsToSave.append(s)
                                //print(s)
                                }
                
            }
        }
        
        
      
        recipeToLoad?.title = titleToSave
        recipeToLoad?.ingredients = ingredientsToSave
        recipeToLoad?.instructions = instructionsToSave
      
      
      if (BackendlessManager.sharedInstance.isUserLoggedIn()) {
        saveBtn.isEnabled = false
        BackendlessManager.sharedInstance.saveRecipe(recipeData: recipeToLoad!,
                                                     completion: {
                                                      self.saveBtn.isEnabled = true
                                                      self.synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
                                                      //  print("Segue to Table of Saved Recipes after data is saved in BE")
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
      } else {
      // If not logged in then user is prompted to register or sign in
        // Create an alert that unwinds to register/log in page with recipe to save
      
        let alertController = UIAlertController(title: "Sign In to save this recipe", message: "Do you want to continue to save this recipe?", preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "OK", style: .default,
                                     handler:  {action in
                                      self.saveRecipeToArchiver()
                                      self.performSegue(withIdentifier: "unwindToWelcomeViewController", sender: self)})
        
        
        alertController.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
      
        self.present(alertController, animated: true, completion: nil)
      }
      
    }
  
  // Save to NSKeyed Archiver
  
  func saveRecipeToArchiver() {
    if let recipeToLoad = recipeToLoad {
    let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(recipeToLoad, toFile: RecipeData.ArchiverUrl.path)
      if !isSuccessfulSave {
        print("Failed to archive recipe")
      }
      else {print("Saved recipe to archive")}
    }
    
    
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
        
        let index = (indexPath as IndexPath).row
        
        cell.index = index
        
        cell.recipeTextView.text = myRecipeStructArray[index].recipeName
      //  print("Row Number = \((indexPath as IndexPath).row)")
       // print("\(cell.recipeTextView.text)")
        
        cell.recipeTextView.isUserInteractionEnabled = false
        cell.recipeTextView.delegate = self
        
        return cell
    }
    
    // From UITableViewDelegate protocol.
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    // From UITableViewDelegate protocol.
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        
        
    }
    
        
    // From UITableViewDelegate protocol.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor = UIColor.brown
        
        //change start of reading
        if editBtn.isEnabled == true {
            
            synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
            startReadingIndex = indexPath.row
     //       print("start reading index = \(startReadingIndex)")
            rowIsSelected = true
            
        }
        
            }
    
    // Method gets called when the keyboard return key pressed
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String)-> Bool {
        if(text == "\n")
        {
            view.endEditing(true)
            
            return false
        }
        else
        {
            return true
        }
    }
   
    //Hide Keyboard when user touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //Presses return key to exit keyboard
    func textFieldShouldReturn(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return (true)
    }
    
    //Update text view after editing
    func textViewDidEndEditing(_ textView: UITextView) {
        
    //    print("Number of rows = \(tableView.numberOfRows(inSection: 0))")
    //    print("Number of visible rows = \(tableView.visibleCells.count)")
        
        for cell in tableView.visibleCells {
            
            if let cell = cell as? RecipeTableViewCell {
                myRecipeStructArray[cell.index!].recipeName = cell.recipeTextView.text
             //   cell.recipeTextView.isEditable = false
                cell.recipeTextView.isUserInteractionEnabled = false
            }
        }
        
        editBtn.isEnabled = true
        
    }
    
}

