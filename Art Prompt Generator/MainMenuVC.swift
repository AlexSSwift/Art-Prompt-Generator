//
//  ViewController.swift
//  Art Prompt Generator
//
//  Created by Alexander Smith on 10/11/19.
//  Copyright © 2019 Alexander Smith. All rights reserved.
//

import UIKit

class MainMenuVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
  

    @IBOutlet weak var tableView: UITableView!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate   = self
        tableView.dataSource = self
        promptData.retrieveStoredData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return promptData.categories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if promptData.categoriesOpened[promptData.categories[section]] == true {
            let selectedCategory = promptData.categories[section]
            if let data = promptData.data[selectedCategory] {
                return data.count + 1
            } else {
                return 1
            }
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if indexPath.row == 0 {
            //catigories
            if let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: "cell") {
                cell = dequeuedCell
            } else {
                cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            }
            let cellCategory = promptData.categories[indexPath.section]
            cell.textLabel?.text = cellCategory
            
            return cell
        } else {
            //prompts
            if let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: "cell") {
                cell = dequeuedCell
            } else {
                cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            }
            let cellCategory = promptData.categories[indexPath.section]
            let cellPrompts = promptData.data[cellCategory]
            if cellPrompts != nil {
                let cellPrompt = cellPrompts![indexPath.row - 1]
                cell.textLabel?.text = cellPrompt
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let categorySelected = promptData.categories[indexPath.section]
        
        if indexPath.row == 0 {
            if promptData.categoriesOpened[categorySelected] == true {
                promptData.categoriesOpened[categorySelected] = false
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            } else {
                promptData.categoriesOpened[categorySelected] = true
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            }
        }
    }
   
    @IBAction func generatePromptButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let selectPromptVC = storyboard.instantiateViewController(identifier: "SelectPromptVC") as! SelectPromptVC
        selectPromptVC.modalPresentationStyle = .fullScreen
        
        self.present(selectPromptVC, animated: true, completion: nil)
    }
    
    @IBAction func addNewElementButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "CreatPrompt", bundle: nil)
        let newPromptDataVC = storyboard.instantiateViewController(identifier: "NewPromptDataVC") as! NewPromptDataVC
        newPromptDataVC.modalPresentationStyle = .fullScreen
        
        self.present(newPromptDataVC, animated: true, completion: nil)
        newPromptDataVC.promptClosure = {
            self.tableView.reloadData()
        }
    }
    

}

