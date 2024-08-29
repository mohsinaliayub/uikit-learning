//
//  AllListsViewController.swift
//  Checklists
//
//  Created by Mohsin Ali Ayub on 30.08.24.
//

import UIKit

class AllListsViewController: UITableViewController {
    
    /// Default section for our checklist items.
    ///
    /// We only have one section for our Checklist items. So, it's value is 0.
    private let defaultSection = 0
    
    private let cellIdentifier = "ChecklistCell"
    private var lists = [Checklist]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add dummy data
        lists.append(Checklist(name: "Birthdays"))
        lists.append(Checklist(name: "Groceries"))
        lists.append(Checklist(name: "Cool Apps"))
        lists.append(Checklist(name: "To Do"))

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    private func configureCell(_ cell: UITableViewCell, for checklist: Checklist) {
        var configuration = cell.defaultContentConfiguration()
        configuration.text = checklist.name
        
        cell.contentConfiguration = configuration
        cell.accessoryType = .detailDisclosureButton
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        let list = lists[indexPath.row]
        configureCell(cell, for: list)
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let checklist = lists[indexPath.row]
        performSegue(withIdentifier: "ShowChecklist", sender: checklist)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        lists.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChecklist" {
            let controller = segue.destination as! ChecklistViewController
            controller.checklist = sender as? Checklist
        } else if segue.identifier == "AddChecklist" {
            let controller = segue.destination as! ListDetailViewController
            controller.delegate = self
        }
    }
}

extension AllListsViewController: ListDetailViewControllerDelegate {
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        popViewController()
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist) {
        popViewController()
        
        let newRowIndex = lists.count
        lists.append(checklist)
        
        let indexPath = IndexPath(row: newRowIndex, section: defaultSection)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist) {
        popViewController()
        
        guard let index = lists.firstIndex(of: checklist) else { return }
        let indexPath = IndexPath(row: index, section: defaultSection)
        if let cell = tableView.cellForRow(at: indexPath) {
            configureCell(cell, for: checklist)
        }
    }
    
    private func popViewController() {
        navigationController?.popViewController(animated: true)
    }
}
