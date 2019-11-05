//
//  ViewController.swift
//  Art Prompt Generator
//
//  Created by Alexander Smith on 10/11/19.
//  Copyright © 2019 Alexander Smith. All rights reserved.
//

import UIKit

class MainMenuVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // to do: add the ability to edit text. Add reroll buttons.
    
    @IBOutlet weak var tableView: UITableView!
    var categoriesOpened: [String:Bool] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate   = self
        tableView.dataSource = self
        promptData.retrieveStoredData()
        setUpCategoriesOpened()
    }
    
    func setUpCategoriesOpened() {
        for category in promptData.categories {
            categoriesOpened[category] = false
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return promptData.categories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if categoriesOpened[promptData.categories[section]] == true {
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
            cell.backgroundColor = .cyan
            
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
                cell.backgroundColor = .none
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let categorySelected = promptData.categories[indexPath.section]
        
        if indexPath.row == 0 {
            if categoriesOpened[categorySelected] == true {
                categoriesOpened[categorySelected] = false
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            } else {
               categoriesOpened[categorySelected] = true
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       
        
        if editingStyle == .delete {
            let cell = indexPath.row
            let thisCategory = promptData.categories[indexPath.section]
           
            if cell == 0 {
                let deleteAlert = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this category and it's contents?", preferredStyle: .alert)
                
                let ok = UIAlertAction(title: "Delete", style: .default, handler: { (action) -> Void in
                    promptData.deleteCatagoryAndData(category: indexPath.section)
                    tableView.beginUpdates()
                    tableView.deleteSections([indexPath.section], with: .none)
                    tableView.deleteRows(at: [indexPath], with: .none)
                    tableView.endUpdates()
                })
                let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                    // do nothing
                }
                deleteAlert.addAction(ok)
                deleteAlert.addAction(cancel)
                
                self.present(deleteAlert, animated: true, completion: nil)
            } else {
                promptData.data[thisCategory]?.remove(at: cell - 1)
                tableView.beginUpdates()
                
                tableView.deleteRows(at: [indexPath], with: .none)
                tableView.endUpdates()
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: "Edit") { (action, view, complete) in
            let cell = tableView.cellForRow(at: indexPath)
            let thisCategory = promptData.categories[indexPath.section]
            let prompts = promptData.data[thisCategory]
            let thisPrompt = prompts?[indexPath.row - 1]
            if thisPrompt != nil {
                let storyboard = UIStoryboard(name: "CreatPrompt", bundle: nil)
                let newPromptTypeVC = storyboard.instantiateViewController(withIdentifier: "NewPromptTypeVC") as! NewPromptTypeVC
                //newPromptTypeVC.modalPresentationStyle = .fullScreen
                newPromptTypeVC.stringToEdit = thisPrompt!
                newPromptTypeVC.task = .editPrompt
                
                self.present(newPromptTypeVC, animated: true, completion: nil)
                
                newPromptTypeVC.newTypeClosure = {
                    let prompt = $0
                    promptData.data[thisCategory]?.insert(prompt, at: indexPath.row - 1)
                    promptData.data[thisCategory]?.remove(at: indexPath.row)
                    cell?.textLabel?.text = prompt
                }
                
                complete(true)
            }
        }
        return UISwipeActionsConfiguration(actions: [edit])
        
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

