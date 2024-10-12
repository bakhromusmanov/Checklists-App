//
//  ChooseFolderViewController.swift
//  Checklists
//
//  Created by Bakhrom Usmanov on 11/10/24.
//

import UIKit

class ChooseFolderViewController : UITableViewController {
    
    weak var delegate: ChooseFolderControllerDelegate?
    var folderIcons: FolderIcons!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Custom Functions
    func configureIconImage(for cell: UITableViewCell, with imageName: String) {
        let imageView = cell.viewWithTag(1005) as! UIImageView
        imageView.image = UIImage(named: imageName)
    }
    
    func configureIconLabel(for cell: UITableViewCell, with imageName: String) {
        let label = cell.viewWithTag(1004) as! UILabel
        label.text = imageName
    }
    
    func configureCheckmark(for cell: UITableViewCell, with imageName: String) {
        if imageName == folderIcons.iconToEditName {
            cell.accessoryType = .checkmark
        }
    }
    
    func configurePreviousCheckmark(){
        let prevFolderName = folderIcons.iconToEditName
        if let prevIndex = folderIcons.getIndexOfFolder(named: prevFolderName){
            let prevIndexPath = IndexPath(row: prevIndex, section: 0)
            let prevCell = tableView.cellForRow(at: prevIndexPath)
            prevCell?.accessoryType = .none
        }
    }
    
    //MARK: - Table View Delegates
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        configurePreviousCheckmark()
        let folderName = folderIcons.getIconName(at: indexPath.row)
        folderIcons.iconToEditName = folderName
        if let cell = tableView.cellForRow(at: indexPath) {
            configureCheckmark(for: cell, with: folderName)
            delegate?.chooseFolderController(self, didPick: folderName)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folderIcons.iconsCount()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FolderCell", for: indexPath)
        let imageName = folderIcons.getIconName(at: indexPath.row)
        configureIconImage(for: cell, with: imageName)
        configureIconLabel(for: cell, with: imageName)
        configureCheckmark(for: cell, with: imageName)
        return cell
    }
}

protocol ChooseFolderControllerDelegate : AnyObject {
    func chooseFolderController(_ controller: ChooseFolderViewController, didPick folderName: String)
}
