//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Mohsin Ali Ayub on 27.08.24.
//

import Foundation
import UserNotifications

class ChecklistItem: NSObject, Codable {
    /// The task to be performed.
    var text: String
    var checked = false
    /// The `Date` to receive a reminder.
    ///
    /// The reminder will only be triggered if ``shouldRemind`` is **true** and the **Date** is in the future.
    var dueDate = Date()
    /// A toggle that lets you schedule a notification in the future.
    var shouldRemind = false
    /// A unique identifier.
    let itemID: Int
    
    init(text: String, checked: Bool = false) {
        self.text = text
        self.checked = checked
        itemID = DataModel.nextChecklistItemID()
    }
    
    deinit {
        removeNotification()
    }
    
    /// Schedules a local notification for this ChecklistItem.
    ///
    /// Notification is only scheduled if ``shouldRemind`` is **true** and ``dueDate`` is in the future.
    func scheduleNotification() {
        // remove previously scheduled notification
        removeNotification()
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
    }
    
    /// Removes the pending notifications for this ChecklistItem.
    private func removeNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["\(itemID)"])
    }
}
