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
    
    var myRecipeArray = [String]()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var synthesizer = AVSpeechSynthesizer()
    
    @IBOutlet weak var startReading: UIButton!
    @IBOutlet weak var pauseReading: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let recipe = recipeToLoad {
            if let title = recipe.title {
                myRecipeArray.append("Recipe for \(title)")
            }
            if let ingredients = recipe.ingredients {
                myRecipeArray.append("The Ingredients required are: ")
                for i in ingredients {
                    myRecipeArray.append(i)
                }
            
            }
            if let instructions = recipe.instructions {
                //Splitting text into an array of  strings
                let instructionsArray = instructions.components(separatedBy: ".")
                
                myRecipeArray.append("Instructions: ")
                for i in instructionsArray {
                    //Check if string in empty
                    if i != "" {
                    myRecipeArray.append("\(i).")
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
        for speechIndex in myRecipeArray {
            print(speechIndex)
        callSpeechSynthesizer(step: speechIndex)
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
    
    @IBAction func backBtn(_ sender: UIButton) {
        navigationController!.popViewController(animated: true)
    }
    //Speech Synthesizer
    func callSpeechSynthesizer(step: String) {
        
        let utterance = AVSpeechUtterance(string: step)
        print(utterance)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        
    print(utterance.voice?.language)
        
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
        
        
        
    }
    // From UITableViewDataSource protocol.
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    // From UITableViewDataSource protocol.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myRecipeArray.count
    }
    
    // From UITableViewDataSource protocol.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeTableViewCell", for: indexPath) as! RecipeTableViewCell
        
        cell.myLabel.text = myRecipeArray[(indexPath as NSIndexPath).row]
        
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

