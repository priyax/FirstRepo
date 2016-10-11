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

   
}
