//
//  PromptData.swift
//  Art Prompt Generator
//
//  Created by Alexander Smith on 10/11/19.
//  Copyright © 2019 Alexander Smith. All rights reserved.
//

import Foundation

let promptData = PromptData()

class PromptData {
    
    fileprivate init(){
    }
    
    let storedDataKey: String = "storedData"
    var categories: [String] = []
    //var categoriesOpened: [String:Bool] = [:]
    //type name for key, character: [knight, wizard, cleric]
    var data:  [String:[String]] = [:]
 
    func setOrAppendData(which category: Int, prompts: [String]) {
        let selectedCategory = categories[category]
        
        if data[selectedCategory] != nil {
            for prompt in prompts {
                if (data[selectedCategory]?.contains(prompt))! {
                    // do nothing
                } else {
                    data[selectedCategory]?.append(prompt)
                }
            }
            
        } else {
            data[selectedCategory] = prompts
        }
    }
    
    func deleteCatagoryAndData(category: Int){
      let selectedCategory = categories[category]
        data[selectedCategory]?.removeAll()
        categories.remove(at: category)
    }
    
    func storeData() -> [Any] { 
      var buffer:[Any] = []
        let categoriesOpened:[String] = []
        
        buffer.append(categories)
        buffer.append(categoriesOpened)
        buffer.append(data)
        
        return buffer
    }
    
    func retrieveStoredData() {
        guard let guardedRetrievedData = UserDefaults.standard.array(forKey: self.storedDataKey) else {
            print("Error: we could not retrieve the data.")
            return
            }
        categories       = guardedRetrievedData[0] as! [String]
       // categoriesOpened = guardedRetrievedData[1] as! [String:Bool]
        data             = guardedRetrievedData[2] as! [String:[String]]
        
        sortAlphabetically()
    }
    
    func sortAlphabetically() {
        let sortedArray = categories.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
        categories = sortedArray
        
        for category in categories {
            if let guardedData = data[category] {
                let sortedArray = guardedData.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
                data[category] = sortedArray
            }
        }
    }
    
    func editDataCategory(which category: Int, newCategoryName: String) {
        var buffer: [String]
        let thisCategory = categories[category]
        if data[thisCategory] != nil {
            buffer = data[thisCategory]!
            data.removeValue(forKey: thisCategory)
            categories.remove(at: category)
            categories.append(newCategoryName)
            data[newCategoryName] = buffer
        }
    }
    
    
}
