//
//  BackendlessManager.swift
//  textToTableViewController
//
//  Created by Priya Xavier on 10/7/16.
//  Copyright © 2016 Guild/SA. All rights reserved.
//

import Foundation

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
    
    func saveRecipe(recipeData: RecipeData, completion: @escaping () -> (), error: @escaping () -> ())  {
        if recipeData.objectId == nil {
           
            backendless.data.save(recipeData,
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
            
            let dataStore = backendless.persistenceService.of(RecipeData.ofClass())
            
            dataStore?.findID(recipeData.objectId,
                              
          response: { (recipeData: Any?) -> Void in
                    self.backendless.data.save(recipeData,
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

   
}
