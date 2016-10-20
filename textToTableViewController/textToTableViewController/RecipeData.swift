//
//  RecipeData.swift
//  textToTableViewController
//
//  Created by Priya Xavier on 10/14/16.
//  Copyright © 2016 Guild/SA. All rights reserved.

import UIKit
class RecipeData: NSObject {
    var objectId: String?
    var title :String?
    var ingredients :[String]?
    var instructions :[String]?
    var recipeUrl : String?
    var thumbnailUrl :String?

    init(title: String?, ingredients: [String]?, instructions: [String]?, recipeUrl: String?, thumbnailUrl: String?) {
        self.title = title
        self.ingredients = ingredients
        self.instructions = instructions
        self.recipeUrl = recipeUrl
        self.thumbnailUrl = thumbnailUrl
        
    }

}
