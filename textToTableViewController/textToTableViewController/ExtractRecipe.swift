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
    
    struct recipeData {
        var title: String
        var ingredients: [String]
        var instruction: String
    }

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
        
         let parameters: Parameters = [
         "forceExtraction": "false",
         "url": "http://www.melskitchencafe.com/the-best-fudgy-brownies/"
         ]
         
         let headers: HTTPHeaders = [
         "X-Mashape-Key": "pzvlLbDM00mshRETcOj2MRdfKLJzp19j3qcjsniUjlvbaDIiaw"
         ]
         
         Alamofire.request("https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/extract", parameters: parameters, encoding: URLEncoding.default, headers: headers).responseString { response in
         
         // The GET request for the JSON data has returned.
         //print(response.request)  // original URL request
         //print(response.response) // URL response
         print(response.data)     // server data
         //print(response.result)   // result of response serialization
         
         if let jsonString = response.result.value {
            
            let json = JSON.parse(jsonString)
            
            let title = json.dictionaryValue["title"]!.stringValue
            var ingredients = [String]()
            
            for arrayEntry in json.dictionaryValue["extendedIngredients"]!.arrayValue {
                ingredients.append(arrayEntry.dictionaryValue["name"]!.stringValue)
            
            }
           
            let instructions = json.dictionaryValue["text"]!.stringValue
            
            let recipe =  recipeData.init(title: title, ingredients: ingredients, instruction: instructions)
            
         print("recipe title= \(recipe.title)")
        print("ingredients in recipe are = \(recipe.ingredients)")
            print("recipe instructions = \(recipe.instruction)")
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

}
