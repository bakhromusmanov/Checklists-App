//
//  ViewController.swift
//  Checklists
//
//  Created by Bakhrom Usmanov on 01/10/24.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailDelegate {
    
    var checklist: Checklist?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        title = checklist?.title
        /*
        if let checklist = checklist {
            checklist.loadChecklistItems()
            //print("Documents Folder Path: \(checklist.documentsFolder())")
            //print("Data File Path: \(checklist.dataFilePath())")
        }
        */
    }
    
    //MARK: - Custom Functions
    func configureTitle(for cell: UITableViewCell, with item: ChecklistItem){
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.title
    }
    
    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem){
        let checkmarkLabel = cell.viewWithTag(1001) as! UILabel
        checkmarkLabel.text = item.hasCheckmark ? "✓" : ""
    }
}

extension ChecklistViewController {
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem"{
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
            
            if let checklist = checklist, let indexPath = tableView.indexPath(for: sender as! UITableViewCell){
                let rowIndex = indexPath.row
                controller.itemToEdit = checklist.checklistItems[rowIndex]
            }
        }
    }
    
    //MARK: - Add Item Delegate Functions Implementation
    
    func itemDetailControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailController(_ controller: ItemDetailViewController, didFinishAdding itemToAdd: ChecklistItem){
        if let checklist = checklist {
            let rowIndex = checklist.itemsCount
            checklist.addItem(with: itemToAdd)
            let indexPath = IndexPath(row: rowIndex, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
            
            //checklist.saveChecklistItems()
        }
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        if let checklist = checklist, let index = checklist.checklistItems.firstIndex(of: item){
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath){
                configureTitle(for: cell, with: item)
            }
            
            //checklist.saveChecklistItems()
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Table View Delegate Protocol Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let checklist = checklist, let cell = tableView.cellForRow(at: indexPath){
            let item = checklist.getItem(at: indexPath.row)
            item.hasCheckmark.toggle()
            configureCheckmark(for: cell, with: item)
            
            //checklist.saveChecklistItems()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if let checklist = checklist{
            checklist.removeItem(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            //checklist.saveChecklistItems()
        }
    }
    
    //MARK: - Table View Data Source Protocol Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist?.itemsCount ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        if let checklist = checklist {
            let item = checklist.getItem(at: indexPath.row)
            configureTitle(for: cell, with: item)
            configureCheckmark(for: cell, with: item)
        }
        return cell
    }
    
}
