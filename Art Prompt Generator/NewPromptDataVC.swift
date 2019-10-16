//
//  NewPromptData.swift
//  Art Prompt Generator
//
//  Created by Alexander Smith on 10/11/19.
//  Copyright © 2019 Alexander Smith. All rights reserved.
//

import UIKit

class NewPromptDataVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var currentSelectedTypeLabel: UILabel!
    @IBOutlet weak var typePicker: UIPickerView!
    @IBOutlet weak var promptTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var currentCatagory: Int = 0
    var prompts: [String] = []
    var promptClosure: () -> Void = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        typePicker.delegate   = self
        typePicker.dataSource = self
        tableView.delegate    = self
        tableView.dataSource  = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return promptData.categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return promptData.categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentCatagory = row
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        prompts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: "cell") {
            cell = dequeuedCell
        } else {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        let toDoTask = prompts[indexPath.row]
        cell.textLabel?.text = toDoTask
        
        return cell
    }
    
    
    @IBAction func canelButtonPressed(_ sender: UIButton) {
        promptClosure()
        self.dismiss(animated: true, completion: nil)
    }
    
  
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        promptData.setOrAppendData(which: currentCatagory, prompts: prompts)
        promptClosure()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func newCatigoryButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "CreatPrompt", bundle: nil)
        let newPromptTypeVC = storyboard.instantiateViewController(withIdentifier: "NewPromptTypeVC") as! NewPromptTypeVC
        //newPromptTypeVC.modalPresentationStyle = .fullScreen
        
        self.present(newPromptTypeVC, animated: true, completion: nil)
        
        newPromptTypeVC.newTypeClosure = {
            promptData.categories.append($0)
            promptData.categoriesOpened[$0] = false
            promptData.data[$0] = []
            self.typePicker.reloadAllComponents()
        }
    }
    
    @IBAction func deleteCategoryPressed(_ sender: UIButton) {
        let deleteAlert = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this category and it's contents?", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Delete", style: .default, handler: { (action) -> Void in
            promptData.deleteCatagoryAndData(category: self.currentCatagory)
            self.typePicker.reloadAllComponents()
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
           // do nothing
        }
        deleteAlert.addAction(ok)
        deleteAlert.addAction(cancel)
        
        self.present(deleteAlert, animated: true, completion: nil)
    }
    
    @IBAction func okButtonPressed(_ sender: UIButton) {
        if let promptText = promptTextField.text {
            if promptText != "" {
                let lowercased = promptText.lowercased()
                let capitalized = lowercased.capitalized
                
                if prompts.contains(capitalized) {
                    // do nothing
                } else {
                    prompts.append(capitalized)
                    let indexPath = IndexPath(row: prompts.count - 1, section: 0)
                               tableView.beginUpdates()
                               tableView.insertRows(at: [indexPath], with: .none)
                               tableView.endUpdates()
                }
            }
        }
    }
    
    
}
