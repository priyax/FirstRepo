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
    
    
    var synthesizer = AVSpeechSynthesizer()
    
    @IBOutlet weak var startReading: UIButton!
    @IBOutlet weak var pauseReading: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let recipe = recipeToLoad {
            if let title = recipe.title {
                myRecipeArray.append(title)
            }
            if let ingredients = recipe.ingredients {
                for i in ingredients {
                    myRecipeArray.append(i)
                }
            
            }
            if let instructions = recipe.instructions {
                myRecipeArray.append(instructions)
            }
        }
        
        
        
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
        synthesizer.pauseSpeaking(at: AVSpeechBoundary.word)
        
    }
    
    @IBAction func stopReading(_ sender: UIButton) {
        
        synthesizer.stopSpeaking(at: AVSpeechBoundary.word)     }
    
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

