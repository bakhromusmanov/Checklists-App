//
//  ViewController.swift
//  Checklists
//
//  Created by Bakhrom Usmanov on 01/10/24.
//

import UIKit

class ChecklistTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension ChecklistTableViewController {
    //MARK: - Table View Data Source Protocol Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = setNameOfRow(number: indexPath.row)
        return cell
    }
    
    func setNameOfRow(number: Int) -> String {
        switch number {
        case 0: return "Task 1"
        case 1: return "Task 2"
        case 2: return "Task 3"
        case 3: return "Task 4"
        case 4: return "Task 5"
        default: return "Row not initialized"
        }
    }
    
    //MARK: - Table View Delegate Protocol Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath){
            cell.accessoryType = cell.accessoryType == .none ? .checkmark : .none
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
