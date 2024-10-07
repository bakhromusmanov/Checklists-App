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
        let path = dataFilePath()
        
        if let data = try? Data(contentsOf: path){
            let decoder = PropertyListDecoder()
            do {
                checklistItems = try decoder.decode([ChecklistItem].self, from: data)
            } catch {
                print("Error decoding checklistItems array: \(error.localizedDescription)")
            }
        }
    }
}
