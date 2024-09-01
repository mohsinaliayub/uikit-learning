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
    }
    
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
        } catch {
            print("Error decoding list array: \(error.localizedDescription)")
        }
    }
}
