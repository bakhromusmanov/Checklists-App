//
//  DataModel.swift
//  Checklists
//
//  Created by Bakhrom Usmanov on 08/10/24.
//

import Foundation

class DataModel {
    
    var allChecklists: [Checklist]
    
    var checklistsCount: Int {
        return allChecklists.count
    }
    var indexOfSelectedChecklist: Int {
        get {
            return UserDefaults.standard.integer(forKey: "ChecklistIndex")
        } set {
            UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
        }
    }
    
    init() {
        self.allChecklists = []
        registerDefaults()
        loadAllChecklists()
        handleFirstRun()
    }
    
    func getTitle(at index: Int) -> String {
        return allChecklists[index].title
    }
    
    func getChecklist(at index: Int) -> Checklist {
        return allChecklists[index]
    }
    
    func addChecklist(checklist: Checklist) {
        allChecklists.append(checklist)
    }
    
    func removeChecklist(at index: Int){
        allChecklists.remove(at: index)
    }
    
    func getIndexOf(checklist: Checklist) -> Int?{
        return allChecklists.firstIndex(of: checklist)
    }
    
    func sortChecklists(){
        allChecklists.sort(by: <)
    }
    
    func handleFirstRun(){
        let isFirstRun = UserDefaults.standard.bool(forKey: "FirstTime")
        if isFirstRun {
            let checklist = Checklist(title: "List")
            addChecklist(checklist: checklist)
            
            indexOfSelectedChecklist = 0
            UserDefaults.standard.set(false, forKey: "FirstTime")
        }
    }
    
    func getNumberOfTasksLeft(for checklist: Checklist) -> String {
        let allItems = checklist.items
        let uncheckedItems = allItems.filter { !$0.hasCheckmark }
        let subtitle: String
        
        if allItems.count == 0 {
            subtitle = "(No items)"
        } else if uncheckedItems.count == 0 {
            subtitle = "All done"
        } else {
            subtitle = "\(uncheckedItems.count) remaining"
        }
        
        return subtitle
    }
}

extension DataModel {
    //MARK: - Saving Checklists
    func documentsFolder() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentsFolder().appending(path: "Checklists.plist")
    }
    
    func saveAllChecklists(){
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(allChecklists)
            try data.write(to: dataFilePath(), options: .atomic)
        } catch {
            print("Error encoding allChecklists array: \(error.localizedDescription)")
        }
    }
    
    func loadAllChecklists(){
        if let data = try? Data(contentsOf: dataFilePath()){
            let decoder = PropertyListDecoder()
            do {
                allChecklists = try decoder.decode([Checklist].self, from: data)
            } catch {
                print("Error decoding allChecklists array: \(error.localizedDescription)")
            }
        }
    }
    
    func registerDefaults(){
        let dictionary: [String: Any] = [
            "ChecklistIndex" : -1,
            "FirstTime": true]
        UserDefaults.standard.register(defaults: dictionary)
    }
}
