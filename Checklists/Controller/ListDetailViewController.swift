//
//  List.swift
//  Checklists
//
//  Created by Bakhrom Usmanov on 08/10/24.
//

import UIKit

class ListDetailViewController : UITableViewController, UITextFieldDelegate, ChooseFolderControllerDelegate {
    
    weak var delegate: ListDetailDelegate?
    var checklistToEdit: Checklist!
    var temporaryFolderName: String!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var folderImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let checklistToEdit = checklistToEdit {
            doneBarButton.isEnabled = true
            textField.text = checklistToEdit.title
            folderImage.image = UIImage(named: checklistToEdit.folderName)
            temporaryFolderName = checklistToEdit.folderName
            title = "Edit Checklist"
        } else {
            temporaryFolderName = "Folder"
            title = "Add Checklist"
        }
        
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChooseFolder" {
            let controller = segue.destination as! ChooseFolderViewController
            if let checklistToEdit = checklistToEdit {
                let folderIcons = FolderIcons(selectedIcon: checklistToEdit.folderName)
                controller.folderIcons = folderIcons
            } else {
                let folderIcons = FolderIcons(selectedIcon: folderImage.description)
                if let temporaryFolderName = temporaryFolderName {
                    folderIcons.iconToEditName = temporaryFolderName
                } else {
                    folderIcons.iconToEditName = "Folder"
                }
                controller.folderIcons = folderIcons
            }
            controller.delegate = self
        }
    }
    
    //MARK: - Actions
    @IBAction func cancelPressed(){
        if let checklistToEdit = checklistToEdit {
            checklistToEdit.folderName = temporaryFolderName
        }
        delegate?.ChecklistDetailControllerDidCancel(self)
    }
    
    @IBAction func donePressed() {
        if let title = textField.text {
            if let checklistToEdit = checklistToEdit {
                checklistToEdit.title = title
                delegate?.ChecklistDetailController(self, didFinishEditing: checklistToEdit)
            } else {
                let checklist = Checklist(title: title)
                checklist.folderName = temporaryFolderName
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
    
    //MARK: - Choose Folder Delegate Methods
    func chooseFolderController(_ controller: ChooseFolderViewController, didPick folderName: String) {
        folderImage.image = UIImage(named: folderName)
        if let checklistToEdit = checklistToEdit {
            checklistToEdit.folderName = folderName
        } else {
            temporaryFolderName = folderName
        }
    }
}

protocol ListDetailDelegate : AnyObject {
    func ChecklistDetailController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist)
    func ChecklistDetailController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist)
    func ChecklistDetailControllerDidCancel(_ controller: ListDetailViewController)
}
