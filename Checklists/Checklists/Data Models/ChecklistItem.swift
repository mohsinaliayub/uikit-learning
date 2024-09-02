//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Mohsin Ali Ayub on 27.08.24.
//

import Foundation
import UserNotifications

class ChecklistItem: NSObject, Codable {
    var text: String
    var checked = false
    var dueDate = Date()
    var shouldRemind = false
    let itemID: Int
    
    init(text: String, checked: Bool = false) {
        self.text = text
        self.checked = checked
        itemID = DataModel.nextChecklistItemID()
    }
    
    func scheduleNotification() {
        guard shouldRemind && dueDate > Date() else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Reminder:"
        content.body = text
        content.sound = .default
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: dueDate)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(identifier: "\(itemID)", content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request)
        
        print("Scheduled: \(request) for itemID: \(itemID)")
    }
}
