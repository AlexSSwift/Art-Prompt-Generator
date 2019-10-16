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
    var categoriesOpened: [String:Bool] = [:]
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
        
        buffer.append(categories)
        buffer.append(categoriesOpened)
        buffer.append(data)
        
        return buffer
    }
    
    func retrieveStoredData() {
        guard let guardedRetrievedData = UserDefaults.standard.array(forKey: self.storedDataKey) else {
                return
            }
        categories       = guardedRetrievedData[0] as! [String]
        categoriesOpened = guardedRetrievedData[1] as! [String:Bool]
        data             = guardedRetrievedData[2] as! [String:[String]]
    }
    
}
