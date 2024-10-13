//
//  Data Model.swift
//  Checklists
//
//  Created by Bakhrom Usmanov on 02/10/24.
//

import Foundation

class Checklist : Codable, Equatable, Comparable {
    
    var title: String
    var items: [ChecklistItem]
    var folderName: String
    var itemsCount: Int {
        return items.count
    }
    
    init(title: String, checklistItems: [ChecklistItem] = [], folderName: String = "Folder"){
        self.title = title
        self.items = checklistItems
        self.folderName = folderName
    }
    
    func getItem(at index: Int) -> ChecklistItem {
        return items[index]
    }
    
    func getItemTitle(at index: Int) -> String {
        return getItem(at: index).title
    }
    
    func addItem(item: ChecklistItem) {
        items.append(item)
    }
    
    func removeItem(at row: Int){
        items.remove(at: row)
    }
}

extension Checklist {
    static func == (lhs: Checklist, rhs: Checklist) -> Bool {
        return lhs === rhs
    }
    
    static func < (lhs: Checklist, rhs: Checklist) -> Bool {
        return lhs.title.lowercased() < rhs.title.lowercased()
    }
}
