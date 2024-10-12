//
//  AddItemViewController.swift
//  Checklists
//
//  Created by Bakhrom Usmanov on 04/10/24.
//

import UIKit

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {
    weak var delegate: ItemDetailDelegate?
    var itemToEdit: ChecklistItem?
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        if let itemToEdit = itemToEdit {
            doneBarButton.isEnabled = true
            textField.text = itemToEdit.title
            title = "Edit Item"
        } else {
            title = "Add Item"
        }
        
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    //MARK: - Actions
    @IBAction func cancelPressed(){
        delegate?.itemDetailControllerDidCancel(self)
    }
    
    @IBAction func donePressed(){
        if let title = textField.text, isValidInput(text: title) {
            if let itemToEdit = itemToEdit {
                itemToEdit.title = title
                delegate?.itemDetailController(self, didFinishEditing: itemToEdit)
            } else {
                let item = ChecklistItem(title: title)
                delegate?.itemDetailController(self, didFinishAdding: item)
            }
        }
    }
    
    //MARK: - Custom Functions
    func isValidInput(text: String) -> Bool {
        return !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

extension ItemDetailViewController {
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
    func itemDetailControllerDidCancel(_ controller: ItemDetailViewController)
    func itemDetailController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem)
    func itemDetailController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem)
}
