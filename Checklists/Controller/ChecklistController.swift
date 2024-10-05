//
//  ViewController.swift
//  Checklists
//
//  Created by Bakhrom Usmanov on 01/10/24.
//

import UIKit

class ChecklistController: UITableViewController {
    
    let dataModel = DataModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .always
    }
    
    // MARK: - Actions

    
    //MARK: - Custom Functions
    func configureTitle(for cell: UITableViewCell, with item: ChecklistItem){
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.title
    }
    
    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem){
        cell.accessoryType = item.hasCheckmark ? .checkmark : .none
    }
    
    func addItem(title: String){
        print(title)
        let rowIndex = dataModel.itemsCount
        dataModel.addItem(title: title)
        
        let indexPath = IndexPath(row: rowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
}

extension ChecklistController {
    
    //MARK: - Table View Delegate Protocol Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath){
            let item = dataModel.getItem(at: indexPath.row)
            item.hasCheckmark.toggle()
            configureCheckmark(for: cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        dataModel.removeItem(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    //MARK: - Table View Data Source Protocol Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.itemsCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        let item = dataModel.getItem(at: indexPath.row)
        configureTitle(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        return cell
    }
}
