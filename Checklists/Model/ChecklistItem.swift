//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Bakhrom Usmanov on 02/10/24.
//

import Foundation

class ChecklistItem : Codable {
    var title: String
    var hasCheckmark: Bool
    
    init(title: String, hasCheckmark: Bool = false){
        self.title = title
        self.hasCheckmark = hasCheckmark
    }
}
