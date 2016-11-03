//
//  BackendlessManager.swift
//  textToTableViewController
//
//  Created by Priya Xavier on 10/7/16.
//  Copyright © 2016 Guild/SA. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class BackendlessManager {
    
    // This gives access to the one and only instance.
    static let sharedInstance = BackendlessManager()
    
    // This prevents others from using the default '()' initializer for this class.
    private init() {}
    
    let backendless = Backendless.sharedInstance()!
    
    let VERSION_NUM = "v1"
    let APP_ID = "CA70AB01-FC31-9E28-FFAC-025AA0445600"
    let SECRET_KEY = "89555DE6-8505-58D6-FFA8-B95276FFB200"
    
    func initApp() {
        
        // First, init Backendless!
        backendless.initApp(APP_ID, secret:SECRET_KEY, version:VERSION_NUM)
        backendless.userService.setStayLoggedIn(true)
    }
    
    func isUserLoggedIn() -> Bool {
        
        let isValidUser = backendless.userService.isValidUserToken()
        
        if isValidUser != nil && isValidUser != 0 {
            return true
        } else {
            return false
        }
    }

    
    
    func registerUser(email: String, password: String, completion: @escaping () -> (), error: @escaping (String) -> ()) {
    
        let user: BackendlessUser = BackendlessUser()
        user.email = email as NSString!
        user.password = password as NSString!
        
        backendless.userService.registering( user,
                                              
            response: { (user: BackendlessUser?) -> Void in
            
                print("User was registered: \(user?.objectId)")
                completion()
            },
          
            error: { (fault: Fault?) -> Void in
                print("User failed to register: \(fault)")
                error((fault?.message)!)
            }
        )
    }
    
    func loginUser(email: String, password: String, completion: @escaping () -> (), error: @escaping (String) -> ()) {
        
        backendless.userService.login( email, password: password,
                                        
            response: { (user: BackendlessUser?) -> Void in
                print("User logged in: \(user!.objectId)")
                completion()
            },
            
            error: { (fault: Fault?) -> Void in
                print("User failed to login: \(fault)")
                error((fault?.message)!)
            })
     
    }
    
    func logoutUser(completion: @escaping () -> (), error: @escaping (String) -> ()) {
        
        // First, check if the user is actually logged in.
        if isUserLoggedIn() {
            
            // If they are currently logged in - go ahead and log them out!
            
            backendless.userService.logout( { (user: Any!) -> Void in
                    print("User logged out!")
                    completion()
                },
                                            
                error: { (fault: Fault?) -> Void in
                    print("User failed to log out: \(fault)")
                    error((fault?.message)!)
                })
            
        } else {
            
            print("User is already logged out!");
            completion()
        }
    }
    
    
    func loadRecipes(completion: @escaping ([RecipeData]) -> ()) {
        
        let dataStore = backendless.persistenceService.of(RecipeForBE.ofClass())
        
        let dataQuery = BackendlessDataQuery()
        // Only get the Recipes that belong to our logged in user!
        dataQuery.whereClause = "ownerId = '\(backendless.userService.currentUser.objectId!)'"
        
        
        dataStore?.find(dataQuery,
                         
             response: { (recipes: BackendlessCollection?) -> Void in
                
                print("Find attempt on all Meals has completed without error!")
                print("Number of Meals found = \((recipes?.data.count)!)")
                
                var recipeData = [RecipeData]()
                
                for recipe in (recipes?.data)! {
                    
                    let recipefromBE = recipe as! RecipeForBE
                    
                    
                    //Convert JSON ingredients into a string array
                    var ingredients = [String]()
                    if let jsonIngredientsString = recipefromBE.ingredients {
                    
                            for arrayEntry in JSON.parse(jsonIngredientsString).arrayValue {
                                ingredients.append(arrayEntry.stringValue)
                            }
                        }
                 //Convert JSON instructions into a string array
                    var instructions = [String]()
                    if let jsonInstructionsString = recipefromBE.instructions {
                        
                        for arrayEntry in JSON.parse(jsonInstructionsString).arrayValue {
                            instructions.append(arrayEntry.stringValue)
                        }
                    }
                    
                    let newRecipeData = RecipeData(title: recipefromBE.title, ingredients: ingredients, instructions: instructions, recipeUrl: recipefromBE.recipeUrl, thumbnailUrl: recipefromBE.thumbnailUrl)
                    recipeData.append(newRecipeData!)
                    
                    newRecipeData?.objectId = recipefromBE.objectId
                    
                    print("Recipe Id: \(recipefromBE.objectId!), Title: \(recipefromBE.title), photoUrl: \(recipefromBE.thumbnailUrl!), recipeUrl \(recipefromBE.recipeUrl), recipeInstructions \(instructions)")
                }
                
                            // Whatever meals we found on the database - return them.
                            completion(recipeData)
        },
                         
                         error: { (fault: Fault?) -> Void in
                            print("Failed to find Meal: \(fault)")
        }
        )
    }

    
    func saveRecipe(recipeData: RecipeData, completion: @escaping () -> (), error: @escaping () -> ())  {
        let recipeToSave = RecipeForBE()
        recipeToSave.title = recipeData.title
        recipeToSave.recipeUrl = recipeData.recipeUrl
        recipeToSave.thumbnailUrl = recipeData.thumbnailUrl
        
        if let recipeIng = recipeData.ingredients {
            let ingredientsJSON = JSON(recipeIng)
            recipeToSave.ingredients = ingredientsJSON.rawString(String.Encoding.utf8, options: [])}
        
        if let recipeInst = recipeData.instructions {
            let instructionsJSON = JSON(recipeInst)
            recipeToSave.instructions = instructionsJSON.rawString(String.Encoding.utf8, options: [])}
       
        
        print("\(recipeToSave.instructions)")
        let dataStore = backendless.data.of(RecipeForBE.ofClass())
        if recipeToSave.objectId == nil {
           
           dataStore?.save(recipeToSave,
                                  response: {(result: Any!) -> Void in
                                    
                                    print("Recipe has been saved")
                                    completion()
                                    },
                                  error: { (fault: Fault?) -> Void in
                                    print("Recipe failed to save\(fault)")
                                    error()
                                    })
            
        
        }
        else {
            
            //
            // Update the existing Recipe
            //
            
            let dataStore = backendless.persistenceService.of(RecipeForBE.ofClass())
            
            dataStore?.findID(recipeToSave.objectId,
                              
          response: { (result: Any?) -> Void in
                    let foundRecipe = result as! RecipeForBE
                    self.backendless.data.save(foundRecipe,
                                   response: {(result: Any!) -> Void in
                                    print("Recipe has been saved")
                                    completion()
                                    },
                                   error: { (fault: Fault?) -> Void in
                                    print("Recipe failed to save\(fault)")
                                    error()
                                    })
                    },
          error: { (fault: Fault?) -> Void in
            print("Failed to find Recipe: \(fault)")
            error()

            })
        }
    }

    
    func removeRecipe(recipeToRemove: RecipeData, completion: @escaping () -> (), error: @escaping () -> ()) {
        
        print("Remove Recipe: \(recipeToRemove.objectId!)")
        
        let dataStore = backendless.persistenceService.of(RecipeForBE.ofClass())
        
        _ = dataStore?.removeID(recipeToRemove.objectId,
                                
                                response: { (result: NSNumber?) -> Void in
                                    
                                    print("One recipe has been removed: \(result)")
                                    completion()
        },
                                
                                error: { (fault: Fault?) -> Void in
                                    print("Failed to remove Meal: \(fault)")
                                    error()
        }
        )
    }
   
}
