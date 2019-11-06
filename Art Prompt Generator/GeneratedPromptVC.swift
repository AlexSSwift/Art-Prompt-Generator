//
//  GeneratedPrompt.swift
//  Art Prompt Generator
//
//  Created by Alexander Smith on 10/11/19.
//  Copyright © 2019 Alexander Smith. All rights reserved.
//

import UIKit

class GeneratedPromptVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var selectedCategories:[String]      = []
    var whichPromptForCell:[String:Int]  = [:]
    var randomizedPrompts:[String:[String]] = [:]
   
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate   = self
        tableView.dataSource = self
        randomizePrompts()
    }
    
    func randomizePrompts() {
        for category in selectedCategories {
            let data = promptData.data[category]?.shuffled()
            randomizedPrompts[category] = data ?? ["Error: could not find prompt."]
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        let row          = indexPath.row
        let thisCategory = selectedCategories[indexPath.row]
        let prompt      = randomizedPrompts[thisCategory]?.first
     
        if let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: "cell") {
            cell = dequeuedCell
        } else {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        }
        
        cell.textLabel?.text                        = selectedCategories[row]
        cell.detailTextLabel?.text                  = prompt
        whichPromptForCell[selectedCategories[row]] = 0
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let reroll = UIContextualAction(style: .normal, title: "Reroll") { (action, view, complete) in
            let cell          = tableView.cellForRow(at: indexPath)
            let thisCategory  = self.selectedCategories[indexPath.row]
            guard let prompts = self.randomizedPrompts[thisCategory] else {
                complete(true)
                return
            }
            guard let whichPrompt = self.whichPromptForCell[thisCategory]else {
                complete(true)
                return
            }
            if whichPrompt <= prompts.count - 1 {
                
                let nextPrompt = whichPrompt + 1
                self.whichPromptForCell[thisCategory]! += 1
                
                cell?.detailTextLabel?.text = prompts[nextPrompt]
                complete(true)
            }
        }
        return UISwipeActionsConfiguration(actions: [reroll])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let reroll = UIContextualAction(style: .normal, title: "Reroll") { (action, view, complete) in
            let cell          = tableView.cellForRow(at: indexPath)
            let thisCategory  = self.selectedCategories[indexPath.row]
            guard let prompts = self.randomizedPrompts[thisCategory] else {
                complete(true)
                return
            }
            guard let whichPrompt = self.whichPromptForCell[thisCategory]else {
                complete(true)
                return
            }
            if whichPrompt <= prompts.count - 1 {
                
                let nextPrompt = whichPrompt + 1
                self.whichPromptForCell[thisCategory]! += 1
                
                cell?.detailTextLabel?.text = prompts[nextPrompt]
                complete(true)
            }
        }
        return UISwipeActionsConfiguration(actions: [reroll])
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        selectedCategories = []
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func rerollAll(_ sender: UIButton) {
        for (index, category) in selectedCategories.enumerated() {
            guard let prompts = randomizedPrompts[category] else{
                print("Error: could not get prompt for randomization.")
                return
            }
            
            var thisPrompt:String
            let promptPlusOne = (whichPromptForCell[category] ?? 0) + 1
            thisPrompt = prompts[promptPlusOne]
            if self.whichPromptForCell[category] != nil {
                self.whichPromptForCell[category]! += 1
            }
            
            if whichPromptForCell[category] == prompts.count - 1 {
                whichPromptForCell[category] = 0
                randomizedPrompts[category]?.shuffle()
                thisPrompt = randomizedPrompts[category]?.first ?? "Error: could not get prompt for randomization."
            }
            
            let indexPath:IndexPath = IndexPath(row: index, section: 0)
            let cell = tableView.cellForRow(at: indexPath)
            
            tableView.beginUpdates()
            cell?.detailTextLabel?.text = thisPrompt
            tableView.endUpdates()
            
        }
    }
    
    
    
}
