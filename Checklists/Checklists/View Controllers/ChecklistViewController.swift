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
    
    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy HH:mm"
        
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = checklist.name
    }
    
    private func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
        
        let dateLabel = cell.viewWithTag(1002) as! UILabel
        let dateText: String
        if item.dueDate <= Date() {
            dateText = ""
        } else {
            dateText = "Due: \(dateFormatter.string(from: item.dueDate))"
        }
        dateLabel.text = dateText
//        dateLabel.isHidden = item.dueDate <= Date()
    }
    
    private func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(1001) as! UILabel
        label.isHidden = !item.checked
    }
    
    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        checklist.itemCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        let item = checklist.item(at: indexPath.row)
        
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        
        return cell
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = checklist.item(at: indexPath.row)
            item.checked.toggle()
            
            configureCheckmark(for: cell, with: item)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        checklist.removeItem(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
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
                controller.itemToEdit = checklist.item(at: indexPath.row)
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
        
        let newRowIndex = checklist.itemCount
        _ = checklist.add(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: defaultSection)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        popViewController()
        
        guard let index = checklist.index(of: item) else { return }
        let indexPath = IndexPath(row: index, section: defaultSection)
        if let cell = tableView.cellForRow(at: indexPath) {
            configureText(for: cell, with: item)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    private func popViewController() {
        navigationController?.popViewController(animated: true)
    }
}
