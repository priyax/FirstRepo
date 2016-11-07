//
//  TypingRecipesViewController.swift
//  textToTableViewController
//
//  Created by Priya Xavier on 10/14/16.
//  Copyright © 2016 Guild/SA. All rights reserved.
//

import UIKit

class TypingRecipesViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var recipeIngredients: UITextView!
    
    @IBOutlet weak var recipeInstructions: UITextView!
    @IBOutlet weak var recipeTitle: UITextField!
    var recipeEntered: RecipeData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeIngredients.delegate = self
        recipeInstructions.delegate = self
        recipeTitle.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func cancelBtn(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func selectBtn(_ sender: UIButton) {
        
           }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        
        if segue.identifier == "gotoReadRecipesFromTyping" {
            
            print("Preparing to go to read Recipes view after typing!")
            let title = recipeTitle.text
            let instructions = recipeInstructions.text.components(separatedBy: ".")
            let ingredients = recipeIngredients.text.components(separatedBy: NSCharacterSet.newlines)
            recipeEntered = RecipeData(title: title, ingredients: ingredients, instructions: instructions, recipeUrl: nil, thumbnailUrl: nil)
            
            print("title: \(recipeEntered?.title)")
            print("instructions: \(recipeEntered?.instructions)")
            print("instructions: \(recipeEntered?.ingredients)")

            
            // If we need to, modify the next UIViewController.
            let nextVC = segue.destination as! ReadRecipesController
            
            nextVC.recipeToLoad = self.recipeEntered
        }
        
    }
    
    //Hide Keyboard when user touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //Presses return key to exit keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return (true)
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
}
