//
//  AddItemViewController.swift
//  Checklists
//
//  Created by Bakhrom Usmanov on 04/10/24.
//

import UIKit

class AddItemController: UITableViewController, UITextFieldDelegate {
    weak var delegate: AddItemDelegate?
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        textField.becomeFirstResponder()
    }
    
    //MARK: - Actions
    @IBAction func cancelPressed(){
        delegate?.addItemDidCancel(self)
    }
    
    @IBAction func donePressed(){
        if let title = textField.text, isValidInput(text: title) {
            delegate?.addItem(self, title: title)
        }
    }
    
    //MARK: - Custom Functions
    func isValidInput(text: String) -> Bool {
        return !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

}

extension AddItemController {
    //MARK: - Text Field Delegate Protocol Methods
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let oldText = textField.text, let range = Range(range, in: oldText) {
            let newText = oldText.replacingCharacters(in: range, with: string)
            doneBarButton.isEnabled = isValidInput(text: newText)
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let text = textField.text ?? ""
        return isValidInput(text: text)
    }
}

protocol AddItemDelegate : AnyObject {
    func addItemDidCancel(_ controller: AddItemController)
    func addItem(_ controller: AddItemController, title: String)
}
