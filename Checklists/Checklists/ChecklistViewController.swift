//
//  ViewController.swift
//  Checklists
//
//  Created by Mohsin Ali Ayub on 26.08.24.
//

import UIKit

class ChecklistViewController: UITableViewController {
    
    /// Default section for our checklist items.
    ///
    /// We only have one section for our Checklist items. So, it's value is 0.
    private let defaultSection = 0
    var checklist: Checklist!
    var items = [ChecklistItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = checklist.name
        
        loadChecklistItems()
    }
    
    private func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    private func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(1001) as! UILabel
        label.isHidden = !item.checked
    }
    
    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        let item = items[indexPath.row]
        
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        
        return cell
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = items[indexPath.row]
            item.checked.toggle()
            
            configureCheckmark(for: cell, with: item)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        saveChecklistItems()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        items.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
        saveChecklistItems()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = items[indexPath.row]
            }
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
    
    private func saveChecklistItems() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(items)
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        } catch {
            print("Error encoding items array: \(error.localizedDescription)")
        }
    }
    
    private func loadChecklistItems() {
        let path = dataFilePath()
        
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            
            do {
                items = try decoder.decode([ChecklistItem].self, from: data)
            } catch {
                print("Error decoding items array: \(error.localizedDescription)")
            }
        }
    }
}

extension ChecklistViewController: ItemDetailViewControllerDelegate {
    
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        popViewController()
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        popViewController()
        
        let newRowIndex = items.count
        items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: defaultSection)
        tableView.insertRows(at: [indexPath], with: .automatic)
        
        saveChecklistItems()
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        popViewController()
        
        guard let index = items.firstIndex(of: item) else { return }
        let indexPath = IndexPath(row: index, section: defaultSection)
        if let cell = tableView.cellForRow(at: indexPath) {
            configureText(for: cell, with: item)
        }
        
        saveChecklistItems()
    }
    
    private func popViewController() {
        navigationController?.popViewController(animated: true)
    }
}
