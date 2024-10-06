//
//  Data Model.swift
//  Checklists
//
//  Created by Bakhrom Usmanov on 02/10/24.
//

import Foundation

class DataModel {
    var checklistItems: [ChecklistItem]
    var itemsCount: Int {
        return checklistItems.count
    }
    
    init(){
        self.checklistItems = []
    }
    
    func getItem(at index: Int) -> ChecklistItem {
        return checklistItems[index]
    }
    
    func getTitle(at index: Int) -> String {
        return getItem(at: index).title
    }
    
    func addItem(title: String, hasCheckmark: Bool = false){
        let item = ChecklistItem(title: title, hasCheckmark: hasCheckmark)
        checklistItems.append(item)
    }
    
    func editItem(at index: Int, newTitle: String){
        checklistItems[index].title = newTitle
    }
    
    func removeItem(at row: Int){
        checklistItems.remove(at: row)
    }
}
