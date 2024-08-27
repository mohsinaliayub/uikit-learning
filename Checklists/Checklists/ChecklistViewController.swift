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
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        items.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            let controller = segue.destination as! AddItemViewController
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
            let controller = segue.destination as! AddItemViewController
            controller.delegate = self
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = items[indexPath.row]
            }
        }
    }
}

extension ChecklistViewController: AddItemViewControllerDelegate {
    
    func addItemViewControllerDidCancel(_ controller: AddItemViewController) {
        popViewController()
    }
    
    func addItemViewController(_ controller: AddItemViewController, didFinishAdding item: ChecklistItem) {
        popViewController()
        
        let newRowIndex = items.count
        items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: defaultSection)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    func addItemViewController(_ controller: AddItemViewController, didFinishEditing item: ChecklistItem) {
        popViewController()
        
        guard let index = items.firstIndex(of: item) else { return }
        let indexPath = IndexPath(row: index, section: defaultSection)
        if let cell = tableView.cellForRow(at: indexPath) {
            configureText(for: cell, with: item)
        }
    }
    
    private func popViewController() {
        navigationController?.popViewController(animated: true)
    }
}
