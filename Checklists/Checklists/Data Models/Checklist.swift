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
    /// The icon name for the checklist. The icons are included in the Asset catalog.
    var iconName: String
    
    init(name: String, iconName: String = "No Icon") {
        self.name = name
        self.iconName = iconName
        items = []
        super.init()
    }
}
