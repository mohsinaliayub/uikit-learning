//
//  DataModel.swift
//  Checklists
//
//  Created by Mohsin Ali Ayub on 30.08.24.
//

import Foundation

class DataModel {
    /// An array of ``Checklist`` created by the user.
    private var checklists: [Checklist] = []
    /// A count of the number of ``Checklist`` created by the user.
    var checklistCount: Int { checklists.count }
    
    /// Index of the selected checklist in table view. It is nil, if there was no checklist selected.
    /// Saved in the UserDefaults.
    var indexOfSelectedChecklist: Int? {
        get { UserDefaults.standard.value(forKey: "ChecklistIndex") as? Int }
        set { UserDefaults.standard.setValue(newValue, forKey: "ChecklistIndex")}
    }
    
    init() {
        loadChecklists()
        registerDefaults()
        handleFirstTime()
    }
    
    class func nextChecklistItemID() -> Int {
        let userDefaults = UserDefaults.standard
        let itemID = userDefaults.integer(forKey: "ChecklistItemID")
        userDefaults.set(itemID + 1, forKey: "ChecklistItemID")
        
        return itemID
    }
    
    private func registerDefaults() {
        let dictionary = ["FirstTime": true]
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    /// If the app is launched for first time, create a checklist and save its index.
    /// User will be navigated to the checklist at first app launch.
    private func handleFirstTime() {
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        
        if firstTime {
            let checklist = Checklist(name: "List")
            checklists.append(checklist)
            
            indexOfSelectedChecklist = 0
            userDefaults.set(false, forKey: "FirstTime")
        }
    }
    
    func sortChecklists() {
        checklists.sort { list1, list2 in
            list1.name.localizedStandardCompare(list2.name) == .orderedAscending
        }
    }
    
    // MARK: - CRUD Operations on Checklist
    
    /// Appends a ``Checklist`` and returns the index it has been added at.
    func add(_ checklist: Checklist) -> Int {
        let newItemIndex = checklists.count
        checklists.append(checklist)
        
        return newItemIndex
    }
    
    /// Fetch a ``Checklist`` at specified index.
    func checklist(at index: Int) -> Checklist {
        checklists[index]
    }
    
    /// Removes a ``Checklist`` at specified index.
    func removeChecklist(at index: Int) {
        checklists.remove(at: index)
    }
    
    /// Finds the index of a ``Checklist``, if it exists.
    func index(of checklist: Checklist) -> Int? {
        checklists.firstIndex(of: checklist)
    }
    
    
    func contains(index: Int) -> Bool {
        checklists.indices.contains(index)
    }
    
    // MARK: - Data Persistence
    
    private func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func dataFilePath() -> URL {
        documentsDirectory().appending(path: "Checklists.plist")
    }
    
    func saveChecklists() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(checklists)
            try data.write(to: dataFilePath(), options: .atomic)
        } catch {
            print("Error encoding list array: \(error.localizedDescription)")
        }
    }
    
    func loadChecklists() {
        let path = dataFilePath()
        guard let data = try? Data(contentsOf: path) else { return }
        
        let decoder = PropertyListDecoder()
        do {
            checklists = try decoder.decode([Checklist].self, from: data)
            sortChecklists()
        } catch {
            print("Error decoding list array: \(error.localizedDescription)")
        }
    }
}
