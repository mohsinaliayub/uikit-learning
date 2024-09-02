//
//  Checklist.swift
//  Checklists
//
//  Created by Mohsin Ali Ayub on 30.08.24.
//

import Foundation

class Checklist: NSObject, Codable {
    /// A name to identify a checklist.
    var name: String
    /// An array of ``ChecklistItem`` related to this checklist.
    private var items: [ChecklistItem]
    /// A count of the number of ``ChecklistItem`` in this checklist.
    var itemCount: Int { items.count }
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
    
    /// Appends a ``ChecklistItem`` and returns the index it has been added at.
    func add(_ item: ChecklistItem) -> Int {
        let newItemIndex = items.count
        items.append(item)
        
        return newItemIndex
    }
    
    /// Fetch a ``ChecklistItem`` at specified index.
    func item(at index: Int) -> ChecklistItem {
        items[index]
    }
    
    /// Removes the item at specified index.
    func removeItem(at index: Int) {
        items.remove(at: index)
    }
    
    /// Finds the index of a ``ChecklistItem``, if it exists.
    func index(of item: ChecklistItem) -> Int? {
        items.firstIndex(of: item)
    }
}
