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
    
    func addItem(title: String, hasCheckmark: Bool = false){
        let item = ChecklistItem(title: title, hasCheckmark: hasCheckmark)
        checklistItems.append(item)
    }
    
    func removeItem(at row: Int){
        checklistItems.remove(at: row)
    }
}
