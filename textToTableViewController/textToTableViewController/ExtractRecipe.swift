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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // This sets the text in the middle of the Nav Bar for this View Controllers.
        self.navigationItem.title = "Search For Recipe"
        
        
        //
        // Set a custom image on the Left Side Bar Buttom item.
        //
        
        // Create a UIImage from our save button art.
        var homeBtnImage = UIImage(named: "home_icon")
        
        // Now, force our image to keep its original colors by setting its rendering mode
        // to AlwaysOriginal. This will keep iOS from converting it to white.
        homeBtnImage = homeBtnImage!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        let rightbarBtnItem = UIBarButtonItem(image: homeBtnImage, style: UIBarButtonItemStyle.plain, target: self, action: #selector(homeBtn(_:)))
        
        // Finally, make Bar Buttom item on the Right-side use our Save Button Image
        // without defaulting it to white.
        self.navigationItem.rightBarButtonItem = rightbarBtnItem
        
        
        //
        // Set a custom image on the Right Side Bar Buttom item.
        //
        
        // Create a UIImage from our back button art.
       var backBtnImage = UIImage(named: "backBtn")
        
        // Now, force our image to keep its original colors by setting its rendering mode
        // to AlwaysOriginal. This will keep iOS from converting it to white.
        backBtnImage = backBtnImage!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        let leftbarBtnItem = UIBarButtonItem(image: backBtnImage, style: UIBarButtonItemStyle.plain, target: self, action: #selector(backBtn(_:)))
        
        // Finally, make Bar Buttom item on the Left-side use our Back Button Image
        // without defaulting it to white.
        self.navigationItem.leftBarButtonItem = leftbarBtnItem
        
        
      /* self.navigationController?.navigationBar.setBackgroundImage(navBarBackgroundImage, forBarMetrics: .Default)*/
        
    }

    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    
    @IBAction func selectRecipe(_ sender: UIButton) {
    
        // Below is an example of how to pass URL parameters and set a HTTP header
        // for your Alamofire GET request:
        
       let recipeUrl = webView.request?.url
        //let recipeUrl = URL(string: "http://www.joyofbaking.com/brownies.html")
        print("REcipe url \(recipeUrl)")
         let parameters: Parameters = [
         "forceExtraction": "false",
         "url": recipeUrl!
         ]
         
         let headers: HTTPHeaders = [
         "X-Mashape-Key": "pzvlLbDM00mshRETcOj2MRdfKLJzp19j3qcjsniUjlvbaDIiaw"
         ]
         print("Parameters \(parameters)")
         Alamofire.request("https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/extract", parameters: parameters, encoding: URLEncoding.default, headers: headers).responseString { response in
         
         // The GET request for the JSON data has returned.
//         print("Response . request \(response.request)")  // original URL request
//         print(response.response) // URL response
//         print(response.data)     // server data
//         print(response.result)   // result of response serialization
         
         if let jsonString = response.result.value {
            
            print("JSON String \(jsonString)")
            let json = JSON.parse(jsonString)
            
            print("JSON  \(json)")
            let title = json.dictionaryValue["title"]?.stringValue
            print("TITLE !!!! \(title)")
            
            var ingredients = [String]()
            
            
            if let ingredientsArray = json.dictionaryValue["extendedIngredients"]?.arrayValue {
                
                for arrayEntry in ingredientsArray {
                    ingredients.append(arrayEntry.dictionaryValue["originalString"]!.stringValue)
                }
            }
           
           let instructionsText = json.dictionaryValue["text"]?.stringValue
            
            //Change instructions into an array of strings
            let separators = CharacterSet(charactersIn: ".\t\n\r")
            let instructions = instructionsText?.components(separatedBy: separators)
            
            //get image url
            var thumbnailUrl = String()
            if let imageUrls = json.dictionaryValue["imageUrls"]?.arrayValue{
                
                for imageUrlEntry in imageUrls {
                     thumbnailUrl = imageUrlEntry.stringValue
                    print("image URL!! = \(thumbnailUrl)")
                    }
                }
           
            
            self.recipeData = RecipeData(title: title, ingredients: ingredients, instructions: instructions, recipeUrl: recipeUrl?.absoluteString, thumbnailUrl: thumbnailUrl)
         
            print(" TITLE IN RECIPE DATA \(self.recipeData?.title)")
            
             self.performSegue(withIdentifier: "gotoReadRecipes", sender: sender)
         } else {
         print("Failed to get a value from the response.")
         }
         }
        
        print("recipe title= \(self.recipeData?.title!)")
       print("ingredients in recipe are = \(self.recipeData?.ingredients!)")
       print("recipe instructions = \(self.recipeData?.instructions!)")
        
       
    
    
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
