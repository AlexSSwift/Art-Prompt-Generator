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
    var selectedCategories: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate   = self
        tableView.dataSource = self
        
    }
    
    func generatePrompt() -> [String] {
        var buffer:[String] = []
        for category in selectedCategories {
            let data = promptData.data[category]?.shuffled()
            if data?.first != nil {
                buffer.append((data?.first)!)
            } else {
                buffer.append("Error: could not find prompt.")
            }
        }
        return buffer
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        let prompt = generatePrompt()
        if let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: "cell") {
            cell = dequeuedCell
        } else {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        }
        
        cell.textLabel?.text = selectedCategories[indexPath.row]
        cell.detailTextLabel?.text = prompt[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let reroll = UIContextualAction(style: .normal, title: "Reroll") { (action, view, complete) in
            let cell = tableView.cellForRow(at: indexPath)
            let thisCategory = promptData.data[self.selectedCategories[indexPath.row]]
            let newRandomPrompt = thisCategory?.shuffled()
            cell?.detailTextLabel?.text = newRandomPrompt?.first
            complete(true)
        }
        return UISwipeActionsConfiguration(actions: [reroll])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let reroll = UIContextualAction(style: .normal, title: "Reroll") { (action, view, complete) in
            let cell = tableView.cellForRow(at: indexPath)
            let thisCategory = promptData.data[self.selectedCategories[indexPath.row]]
            let newRandomPrompt = thisCategory?.shuffled()
            cell?.detailTextLabel?.text = newRandomPrompt?.first
            complete(true)
        }
        return UISwipeActionsConfiguration(actions: [reroll])
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        selectedCategories = []
        self.dismiss(animated: true, completion: nil)
    }
    
}
