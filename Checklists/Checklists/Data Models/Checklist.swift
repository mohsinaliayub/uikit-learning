//
//  Checklist.swift
//  Checklists
//
//  Created by Mohsin Ali Ayub on 30.08.24.
//

import Foundation

class Checklist: NSObject, Codable {
    var name: String
    var items: [ChecklistItem]
    /// The number of unchecked items in the checklist.
    var uncheckedItems: Int {
        items.filter({ !$0.checked }).count
    }
    var iconName = "Appointments"
    
    init(name: String) {
        self.name = name
        items = []
        super.init()
    }
}
