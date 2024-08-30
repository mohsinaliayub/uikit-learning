//
//  Checklist.swift
//  Checklists
//
//  Created by Mohsin Ali Ayub on 30.08.24.
//

import Foundation

class Checklist: NSObject {
    var name: String
    var items: [ChecklistItem]
    
    init(name: String) {
        self.name = name
        items = []
        super.init()
    }
}
