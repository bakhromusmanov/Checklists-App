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
    
    init() {
        self.allChecklists = []
        loadAllChecklists()
    }
    
    func getTitle(at index: Int) -> String {
        return allChecklists[index].title
    }
    
    func getChecklist(at index: Int) -> Checklist {
        return allChecklists[index]
    }
    
    func addChecklist(with checklist: Checklist) {
        allChecklists.append(checklist)
    }
    
    func removeChecklist(at index: Int){
        allChecklists.remove(at: index)
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
}
