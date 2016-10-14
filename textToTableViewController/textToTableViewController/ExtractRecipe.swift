//
//  ViewController.swift
//  textToTableViewController
//
//  Created by Priya Xavier on 10/6/16.
//  Copyright © 2016 Guild/SA. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ExtractRecipe: UIViewController {
    
    var recipeData: RecipeData?
    
   // var recipe :recipeData

    @IBAction func backBtn(_ sender: UIBarButtonItem) {
         _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func homeBtn(_ sender: UIBarButtonItem) {
        let url = URL (string: "http://www.google.com/");
        let requestObj = URLRequest(url: url!);
        webView.loadRequest(requestObj);
    }
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let url = URL (string: "http://www.google.com/");
        let requestObj = URLRequest(url: url!);
        webView.loadRequest(requestObj);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    
    @IBAction func selectRecipe(_ sender: UIButton) {
    
        // Below is an example of how to pass URL parameters and set a HTTP header
        // for your Alamofire GET request:
        
       // let recipeUrl = webView.request?.url
        let recipeUrl = URL(string: "http://www.joyofbaking.com/brownies.html")
        print("REcipe url \(recipeUrl)")
         let parameters: Parameters = [
         "forceExtraction": "false",
         "url": recipeUrl!
         ]
         
         let headers: HTTPHeaders = [
         "X-Mashape-Key": "pzvlLbDM00mshRETcOj2MRdfKLJzp19j3qcjsniUjlvbaDIiaw"
         ]
         
         Alamofire.request("https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/extract", parameters: parameters, encoding: URLEncoding.default, headers: headers).responseString { response in
         
         // The GET request for the JSON data has returned.
//         print(response.request)  // original URL request
//         print(response.response) // URL response
//         print(response.data)     // server data
//         print(response.result)   // result of response serialization
         
         if let jsonString = response.result.value {
            
            let json = JSON.parse(jsonString)
            
            let title = json.dictionaryValue["title"]?.stringValue
            
            var ingredients = [String]()
            
            
            if let ingredientsArray = json.dictionaryValue["extendedIngredients"]?.arrayValue {
                
                for arrayEntry in ingredientsArray {
                    ingredients.append(arrayEntry.dictionaryValue["name"]!.stringValue)
                }
            }
           
           let instructions = json.dictionaryValue["text"]?.stringValue
           let thumbnailUrl = json.dictionaryValue["imageUrls"]?.stringValue
           
            
            self.recipeData = RecipeData(title: title, ingredients: ingredients, instructions: instructions, recipeUrl: recipeUrl?.absoluteString, thumbnailUrl: thumbnailUrl)
//         print("recipe title= \(recipe.title)")
//        print("ingredients in recipe are = \(recipe.ingredients)")
//            print("recipe instructions = \(recipe.instruction)")
            
         } else {
         print("Failed to get a value from the response.")
         }
         }
         

    
    
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
        
        
       if segue.identifier == "gotoReadRecipes" {
            
            print("Preparing to go to read Recipes view!")
            
            // If we need to, modify the next UIViewController.
            let nextVC = segue.destination as! ReadRecipesController
            
            nextVC.recipeToLoad = self.recipeData
        }
    }

}
