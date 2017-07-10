//
//  RecipeData.swift
//  textToTableViewController
//
//  Created by Priya Xavier on 10/14/16.
//  Copyright © 2016 Guild/SA. All rights reserved.

import UIKit
class RecipeData: NSObject, NSCoding {
    
    var objectId: String?
    var title :String?
    var ingredients :[String]?
    var instructions :[String]?
    var recipeUrl : String?
    var thumbnailUrl :String?

    init?(title: String?, ingredients: [String]?, instructions: [String]?, recipeUrl: String?, thumbnailUrl: String?) {
        self.title = title
        self.ingredients = ingredients
        self.instructions = instructions
        self.recipeUrl = recipeUrl
        self.thumbnailUrl = thumbnailUrl
        super.init()
      
      
    }
  
  // Archiving paths
  static var DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
  static let ArchiverUrl = DocumentsDirectory.appendingPathComponent("recipe")
  
  struct PropertyKey {
    static let titleKey = "title"
    static let ingredientsKey = "ingredients"
    static let instructionsKey = "instructions"
    static let recipeUrlKey = "recipeUrl"
    static let thumbnailUrlKey = "thumbnailUrl"
  }

  // Encoding
  
  func encode(with aCoder: NSCoder) {
    
    aCoder.encode(title, forKey: PropertyKey.titleKey)
    aCoder.encode(ingredients, forKey: PropertyKey.ingredientsKey)
    aCoder.encode(instructions, forKey: PropertyKey.instructionsKey)
    aCoder.encode(recipeUrl, forKey: PropertyKey.recipeUrlKey)
    aCoder.encode(thumbnailUrl, forKey: PropertyKey.thumbnailUrlKey)
    
  }
  
  required convenience init?(coder aDecoder: NSCoder) {
    
    let title = aDecoder.decodeObject(forKey: PropertyKey.titleKey) as? String
    let ingredients = aDecoder.decodeObject(forKey: PropertyKey.ingredientsKey)
 as? [String]
     let instructions = aDecoder.decodeObject(forKey: PropertyKey.instructionsKey) as? [String]
      let recipeUrl = aDecoder.decodeObject(forKey: PropertyKey.recipeUrlKey) as? String
      let thumbnailUrl = aDecoder.decodeObject(forKey: PropertyKey.thumbnailUrlKey) as? String
    
    self.init(title: title, ingredients: ingredients, instructions: instructions, recipeUrl: recipeUrl, thumbnailUrl: thumbnailUrl)
    
  }
  
  
}
