//
//  List.swift
//  Checklists
//
//  Created by Bakhrom Usmanov on 08/10/24.
//

import UIKit

class ListDetailViewController : UITableViewController, UITextFieldDelegate {
    var delegate: ListDetailDelegate?
    var checklistToEdit: Checklist!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let checklistToEdit = checklistToEdit {
            doneBarButton.isEnabled = true
            textField.text = checklistToEdit.title
            title = "Edit Checklist"
        } else {
            title = "Add Checklist"
        }
        
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    //MARK: - Actions
    @IBAction func cancelPressed(){
        delegate?.ChecklistDetailControllerDidCancel(self)
    }
    
    @IBAction func donePressed() {
        //get title from label, pass new checklist to delegate with empty items
        if let title = textField.text {
            if let checklistToEdit = checklistToEdit {
                checklistToEdit.title = title
                delegate?.ChecklistDetailController(self, didFinishEditing: checklistToEdit)
            } else {
                let checklist = Checklist(title: title)
                delegate?.ChecklistDetailController(self, didFinishAdding: checklist)
            }
        }
    }
    
    //MARK: - Custom Functions
    func isValidInput(text: String) -> Bool {
        return !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

extension ListDetailViewController {
    //MARK: - TextField Delegate Methods
    
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
        let title = textField.text ?? ""
        return isValidInput(text: title)
    }

}

protocol ListDetailDelegate {
    func ChecklistDetailController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist)
    func ChecklistDetailController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist)
    func ChecklistDetailControllerDidCancel(_ controller: ListDetailViewController)
}
