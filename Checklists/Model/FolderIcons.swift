//
//  FolderIcons.swift
//  Checklists
//
//  Created by Bakhrom Usmanov on 11/10/24.
//

import UIKit
class FolderIcons {
    
    let iconNames: [String]
    var iconToEditName: String
    
    init(selectedIcon: String) {
        self.iconNames = [
            "No Icon",
            "Appointments",
            "Birthdays",
            "Chores",
            "Drinks",
            "Folder",
            "Groceries",
            "Inbox",
            "Photos",
            "Trips" ]
        self.iconToEditName = selectedIcon
    }
    
    func iconsCount() -> Int{
        return iconNames.count
    }
    
    func getIconName(at index: Int) -> String {
        return iconNames[index]
    }
    
    func getIndexOfFolder(named folderName: String) -> Int? {
        return iconNames.firstIndex(of: folderName)
    }
}
