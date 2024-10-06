//
//  AddItemViewController.swift
//  Checklists
//
//  Created by Bakhrom Usmanov on 04/10/24.
//

import UIKit

class ItemDetailController: UITableViewController, UITextFieldDelegate {
    weak var delegate: ItemDetailDelegate?
    var editingItem: (oldTitle: String, index: Int)?
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        if let editingItem = editingItem {
            doneBarButton.isEnabled = true
            textField.text = editingItem.oldTitle
            title = "Edit Item"
        }
        
        navigationItem.largeTitleDisplayMode = .never
        textField.becomeFirstResponder()
    }
    
    //MARK: - Actions
    @IBAction func cancelPressed(){
        delegate?.cancelItem(self)
    }
    
    @IBAction func donePressed(){
        if let title = textField.text, isValidInput(text: title) {
            if let editingItem = editingItem {
                delegate?.editItem(self, newTitle: title, at: editingItem.index)
            } else {
                delegate?.addItem(self, title: title)
            }
        }
    }
    
    //MARK: - Custom Functions
    func isValidInput(text: String) -> Bool {
        return !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

}

extension ItemDetailController {
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

protocol ItemDetailDelegate : AnyObject {
    func cancelItem(_ controller: ItemDetailController)
    func addItem(_ controller: ItemDetailController, title: String)
    func editItem(_ controller: ItemDetailController, newTitle: String, at index: Int)
}