//
//  SelectPromptVC.swift
//  Art Prompt Generator
//
//  Created by Alexander Smith on 10/11/19.
//  Copyright © 2019 Alexander Smith. All rights reserved.
//

import UIKit

class SelectPromptVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var selectedCategories:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate   = self
        tableView.dataSource = self
    }
    
    func errorPopUp() {
        let alert = UIAlertController(title: "Error", message: "Selected category is empty.", preferredStyle: .alert)
                           let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                           alert.addAction(ok)
                           self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return promptData.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: "cell") {
            cell = dequeuedCell
        } else {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        let cellCategory = promptData.categories[indexPath.row]
        cell.textLabel?.text = cellCategory
        cell.accessoryType = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .none {
                cell.accessoryType = .checkmark
                let selectedCategory = promptData.categories[indexPath.row]
                selectedCategories.append(selectedCategory)
            } else {
                cell.accessoryType = .none
                let text = cell.textLabel?.text
                let textToKeep = selectedCategories.filter { $0 != text}
                selectedCategories = textToKeep
            }
        }
    }
    
    @IBAction func generateButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let generatedPromptVC = storyboard.instantiateViewController(identifier: "GeneratedPromptVC") as! GeneratedPromptVC
        generatedPromptVC.modalPresentationStyle = .fullScreen
        var passedData: Bool = false
        let sortedArray = selectedCategories.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
        selectedCategories = sortedArray
        
        for category in selectedCategories {
            if promptData.data[category] != nil && promptData.data[category] != [] {
                
                generatedPromptVC.selectedCategories.append(category)
                passedData = true
            } else {
                errorPopUp()
            }
        }
        
        if passedData == true {
            self.present(generatedPromptVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
