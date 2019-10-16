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
    var newTypeClosure: (String) -> Void = {_ in}
  
    override func viewDidLoad() {
        super.viewDidLoad()

       
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
