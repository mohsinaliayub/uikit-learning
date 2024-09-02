//
//  DataModel.swift
//  Checklists
//
//  Created by Mohsin Ali Ayub on 30.08.24.
//

import Foundation

class DataModel {
    var lists: [Checklist] = []
    
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
            lists.append(checklist)
            
            indexOfSelectedChecklist = 0
            userDefaults.set(false, forKey: "FirstTime")
        }
    }
    
    func sortChecklists() {
        lists.sort { list1, list2 in
            list1.name.localizedStandardCompare(list2.name) == .orderedAscending
        }
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
            let data = try encoder.encode(lists)
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
            lists = try decoder.decode([Checklist].self, from: data)
            sortChecklists()
        } catch {
            print("Error decoding list array: \(error.localizedDescription)")
        }
    }
}
