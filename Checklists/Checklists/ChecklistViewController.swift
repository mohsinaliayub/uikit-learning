//
//  ViewController.swift
//  Checklists
//
//  Created by Mohsin Ali Ayub on 26.08.24.
//

import UIKit

class ChecklistViewController: UITableViewController {
    
    var items = [ChecklistItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        items.append(ChecklistItem(text: "Walk the dog"))
        items.append(ChecklistItem(text: "Brush my teeth", checked: true))
        items.append(ChecklistItem(text: "Learn iOS development", checked: true))
        items.append(ChecklistItem(text: "Soccer practice"))
        items.append(ChecklistItem(text: "Eat ice cream", checked: true))
    }
    
    private func configureCheckmark(for cell: UITableViewCell, at indexPath: IndexPath) {
        let item = items[indexPath.row]
        cell.accessoryType = item.checked ? .checkmark : .none
    }
    
    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        let item = items[indexPath.row]
        
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
        
        configureCheckmark(for: cell, at: indexPath)
        
        return cell
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = items[indexPath.row]
            item.checked.toggle()
            
            configureCheckmark(for: cell, at: indexPath)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

