//
//  AddEditViewController.swift
//  Belt Exam
//
//  Created by Tiange Wang on 9/20/18.
//  Copyright © 2018 Tiange Wang. All rights reserved.
//

import UIKit

protocol AddItemDelegate {
    func saveButtonPressed(_ firstName: String, _ lastName: String, _ number: String, at indexPath: IndexPath?)
    func cancelButtonPressed()
}

protocol EditFromDetailDelegate {
    func saveButtonPressed(_ firstName: String, _ lastName: String, _ number: String)
    func cancelButtonPressed()
}

extension String {
    var isNumeric: Bool {
        guard self.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self).isSubset(of: nums)
    }
}
class AddEditViewController: UIViewController {
    
    var delegate: AddItemDelegate?
    var delegate2: EditFromDetailDelegate?
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var warningLabel: UILabel!
    
    var fnTemp: String = ""
    var lnTemp: String = ""
    var numTemp: String = ""
    var ipTemp: IndexPath?
    var fromDetails: Bool = false
    
    @IBAction func cancelBtn(_ sender: UIBarButtonItem) {
        if fromDetails == true {
            delegate2?.cancelButtonPressed()
        } else {
            delegate?.cancelButtonPressed()
        }
        
    }
    
    @IBAction func saveBtn(_ sender: UIBarButtonItem) {
        if fromDetails == true {
            if numberTextField.text!.count < 7 || numberTextField.text!.isNumeric == false {
                warningLabel.isHidden = false
            } else {
                warningLabel.isHidden = true
                delegate2?.saveButtonPressed(firstNameTextField.text!, lastNameTextField.text!, numberTextField.text!)
            }
        } else {
            if numberTextField.text!.count < 7 || numberTextField.text!.isNumeric == false {
                warningLabel.isHidden = false
            } else {
                warningLabel.isHidden = true
                delegate?.saveButtonPressed(firstNameTextField.text!, lastNameTextField.text!, numberTextField.text!, at: ipTemp)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        warningLabel.isHidden = true
        firstNameTextField.text = fnTemp
        lastNameTextField.text = lnTemp
        numberTextField.text = numTemp
    }

}
