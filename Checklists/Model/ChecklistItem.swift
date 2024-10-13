//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Bakhrom Usmanov on 02/10/24.
//

import Foundation
import UserNotifications

class ChecklistItem : Codable, Equatable {
    
    var title: String
    var hasCheckmark: Bool
    var dueDate = Date()
    var shouldRemind: Bool
    var itemID: Int
    
    init(title: String, hasCheckmark: Bool = false, shouldRemind: Bool = false){
        self.title = title
        self.hasCheckmark = hasCheckmark
        self.shouldRemind = shouldRemind
        self.itemID = DataModel.nextChecklistItemID()
    }
    
    deinit {
        removeNotification()
    }
    
    func removeNotification(){
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["\(itemID)"])
    }
    
    func scheduleNotification(){
        removeNotification()
        guard shouldRemind && dueDate > Date() else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Remainder:"
        content.body = title
        content.sound = .default

        let calendar = Calendar(identifier: .gregorian)
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: dueDate)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: "\(itemID)", content: content, trigger: trigger)

        let center = UNUserNotificationCenter.current()
        center.add(request)
        
        print("Scheduled: \(request) for itemID: \(itemID)")
    }
}

extension ChecklistItem {
    static func == (lhs: ChecklistItem, rhs: ChecklistItem) -> Bool{
        return lhs === rhs
    }
}
