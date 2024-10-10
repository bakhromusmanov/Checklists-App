//
//  AllListsController.swift
//  Checklists
//
//  Created by Bakhrom Usmanov on 08/10/24.
//

import UIKit

class AllListsViewController : UITableViewController, ListDetailDelegate, UINavigationControllerDelegate {
    
    var dataModel: DataModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        print(dataModel.dataFilePath())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.delegate = self
        let rowIndex = dataModel.indexOfSelectedChecklist
        guard rowIndex >= 0 && rowIndex < dataModel.checklistsCount else {return}
        if rowIndex != -1 {
            let checklist = dataModel.allChecklists[rowIndex]
            performSegue(withIdentifier: "OpenChecklist", sender: checklist)
        }
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
                controller.checklistToEdit = dataModel.allChecklists[rowIndex]
                controller.delegate = self
            }
        } else if segue.identifier == "OpenChecklist" {
            let controller = segue.destination as! ChecklistViewController
            let checklist = sender as! Checklist
            controller.checklist = checklist
        }
    }
    
    //MARK: -Navigation Controller Delegates
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController === self {
            dataModel.indexOfSelectedChecklist = -1
        }
    }
    
    //MARK: - Implementation of Checklist Delegate Protocol Methods
    func ChecklistDetailControllerDidCancel(_ controller: ListDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func ChecklistDetailController(_ controller: ListDetailViewController, didFinishAdding checklistToAdd: Checklist) {
        let rowIndex = dataModel.checklistsCount
        dataModel.addChecklist(checklist: checklistToAdd)
        let indexPath = IndexPath(row: rowIndex, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        navigationController?.popViewController(animated: true)
    }
    
    func ChecklistDetailController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist) {
        if let index = dataModel.allChecklists.firstIndex(of: checklist){
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath){
                configureTitle(for: checklist, at: cell)
            }
        }
        navigationController?.popViewController(animated: true)
    }
}
extension AllListsViewController {
    //MARK: - Table View Delegates
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        dataModel.removeChecklist(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let checklist = dataModel.allChecklists[indexPath.row]
        performSegue(withIdentifier: "OpenChecklist", sender: checklist)
        dataModel.indexOfSelectedChecklist = indexPath.row
    }
    
    //MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.checklistsCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Checklist", for: indexPath)
        let rowIndex = indexPath.row
        let checklist = dataModel.getChecklist(at: rowIndex)
        configureTitle(for: checklist, at: cell)
        
        return cell
    }
}

