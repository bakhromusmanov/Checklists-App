//
//  Data Model.swift
//  Checklists
//
//  Created by Bakhrom Usmanov on 02/10/24.
//

import Foundation

class Checklist : Codable, Equatable {
    var title: String
    var items: [ChecklistItem]
    var itemsCount: Int {
        return items.count
    }
    
    init(title: String, checklistItems: [ChecklistItem] = []){
        self.title = title
        self.items = checklistItems
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
}
