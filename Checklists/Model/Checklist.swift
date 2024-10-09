//
//  Data Model.swift
//  Checklists
//
//  Created by Bakhrom Usmanov on 02/10/24.
//

import Foundation

class Checklist : Codable, Equatable {
    var title: String
    var checklistItems: [ChecklistItem]
    var itemsCount: Int {
        return checklistItems.count
    }
    
    init(title: String, checklistItems: [ChecklistItem] = []){
        self.title = title
        self.checklistItems = checklistItems
    }
    
    func getItem(at index: Int) -> ChecklistItem {
        return checklistItems[index]
    }
    
    func getItemTitle(at index: Int) -> String {
        return getItem(at: index).title
    }
    
    func addItem(with item: ChecklistItem) {
        checklistItems.append(item)
    }
    
    func removeItem(at row: Int){
        checklistItems.remove(at: row)
    }
    
    func documentsFolder() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentsFolder().appending(path: "Checklists.plist")
    }
    
    func saveChecklistItems(){
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(checklistItems)
            try data.write(to: dataFilePath(), options: .atomic)
        } catch {
            print("Error encoding checklistItems array: \(error.localizedDescription)")
        }
    }
    
    func loadChecklistItems(){
        if let data = try? Data(contentsOf: dataFilePath()){
            let decoder = PropertyListDecoder()
            do {
                checklistItems = try decoder.decode([ChecklistItem].self, from: data)
            } catch {
                print("Error decoding checklistItems array: \(error.localizedDescription)")
            }
        }
    }
}


extension Checklist {
    static func == (lhs: Checklist, rhs: Checklist) -> Bool {
        return lhs === rhs
    }
}
