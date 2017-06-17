//
//  ArchiveRecipe.swift
//  textToTableViewController
//
//  Created by Priya Xavier on 6/1/17.
//  Copyright © 2017 Guild/SA. All rights reserved.
//

import UIKit

class ArchiveRecipe: NSObject {
  
  // Archiver properties
  var title :String?
  var ingredients :[String]?
  var instructions :[String]?
  var recipeUrl : String?
  var thumbnailUrl :String?
  
  // Archiving paths
  static var DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
  static let ArchiverUrl = DocumentsDirectory.appendPathComponent("recipe")
  
  struct PropertyKey {
    static let titleKey = "title"
    static let ingredientsKey = "ingredients"
    static let instructionsKey = "instructions"
    static let recipeUrlKey = "recipeUrl"
    static let thumbnailUrlKey = "thumbnailUrl"
  }

}
