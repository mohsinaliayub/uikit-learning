//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Mohsin Ali Ayub on 27.08.24.
//

import Foundation

class ChecklistItem {
    var text: String
    var checked = false
    
    init(text: String, checked: Bool = false) {
        self.text = text
        self.checked = checked
    }
}
