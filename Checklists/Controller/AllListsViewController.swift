//
//  AllListsController.swift
//  Checklists
//
//  Created by Bakhrom Usmanov on 08/10/24.
//

import UIKit

class AllListsViewController : UITableViewController, ListDetailDelegate {
    
    var checklistsModel = ChecklistsModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        //checklistsModel.loadAllChecklists()
    }
    
    //MARK: - Custom Functions
    func configureTitle(for checklist: Checklist, at cell: UITableViewCell){
        let label = cell.viewWithTag(1002) as! UILabel
        label.text = checklist.title
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddChecklist" {
            let controller = segue.destination as! ListDetailViewController
            controller.delegate = self
        } else if segue.identifier == "EditChecklist" {
            let controller = segue.destination as! ListDetailViewController
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell){
                let rowIndex = indexPath.row
                controller.checklistToEdit = checklistsModel.allChecklists[rowIndex]
                controller.delegate = self
            }
        } else if segue.identifier == "OpenChecklist" {
            let controller = segue.destination as! ChecklistViewController
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell){
                let rowIndex = indexPath.row
                controller.checklist = checklistsModel.allChecklists[rowIndex]
            }
        }
    }
    
    //MARK: - Implementation of Checklist Delegate Protocol Methods
    func ChecklistDetailControllerDidCancel(_ controller: ListDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func ChecklistDetailController(_ controller: ListDetailViewController, didFinishAdding checklistToAdd: Checklist) {
        let rowIndex = checklistsModel.checklistsCount
        checklistsModel.addChecklist(with: checklistToAdd)
        let indexPath = IndexPath(row: rowIndex, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        navigationController?.popViewController(animated: true)
        
        //checklistsModel.saveAllChecklists()
    }
    
    func ChecklistDetailController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist) {
        if let index = checklistsModel.allChecklists.firstIndex(of: checklist){
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath){
                configureTitle(for: checklist, at: cell)
            }
            //checklistsModel.saveAllChecklists()
        }
        
        navigationController?.popViewController(animated: true)
    }
}
extension AllListsViewController {
    //MARK: - Table View Delegates
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        checklistsModel.removeChecklist(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
        //checklistsModel.saveAllChecklists()
    }
    
    //MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklistsModel.checklistsCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Checklist", for: indexPath)
        let rowIndex = indexPath.row
        let checklist = checklistsModel.getChecklist(at: rowIndex)
        configureTitle(for: checklist, at: cell)
        
        return cell
    }
}

