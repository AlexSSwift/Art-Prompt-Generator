//
//  NewPromptType.swift
//  Art Prompt Generator
//
//  Created by Alexander Smith on 10/11/19.
//  Copyright © 2019 Alexander Smith. All rights reserved.
//

import UIKit

class NewPromptTypeVC: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var vcLabel: UILabel!
    
    var newTypeClosure: (String) -> Void = {_ in}
    var task:vcJob = .newCategory
    var stringToEdit:String = ""
    
    enum vcJob {case newCategory; case editPrompt; case editCategory}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        switch task {
        case .newCategory:
            setupForNewCategory()
        case .editCategory:
            setuoForEditingCategory()
        case .editPrompt:
            setupForEditingPrompt()
        }
    }
    
    func setupForNewCategory() {
        vcLabel.text = "New Category"
    }
    
    func setuoForEditingCategory() {
        vcLabel.text = "Edit Category"
        textField.text = stringToEdit
    }
    
    func setupForEditingPrompt() {
        vcLabel.text = "Edit Prompt"
        textField.text = stringToEdit
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        if let typeText = textField.text {
          let lowercased = typeText.lowercased()
          let capitalized = lowercased.capitalized
            newTypeClosure(capitalized)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
