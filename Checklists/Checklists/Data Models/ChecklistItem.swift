//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Mohsin Ali Ayub on 27.08.24.
//

import Foundation

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
}
