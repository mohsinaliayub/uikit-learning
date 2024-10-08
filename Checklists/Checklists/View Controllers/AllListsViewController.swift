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
    var dataModel: DataModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // register a cell for checklist
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.delegate = self
        
        // restore previously opened checklist, only if the app got terminated
        if let index = dataModel.indexOfSelectedChecklist, dataModel.contains(index: index) {
            let checklist = dataModel.checklist(at: index)
            performSegue(withIdentifier: "ShowChecklist", sender: checklist)
        }
    }
    
    private func configureCell(_ cell: UITableViewCell, for checklist: Checklist) {
        var configuration = cell.defaultContentConfiguration()
        configuration.text = checklist.name
        configuration.secondaryText = itemsRemainingText(for: checklist)
        configuration.image = UIImage(named: checklist.iconName)
        
        cell.contentConfiguration = configuration
        cell.accessoryType = .detailDisclosureButton
    }
    
    private func itemsRemainingText(for checklist: Checklist) -> String {
        let empty = 0
        let uncheckedItems = checklist.uncheckedItems
        let text: String
        
        if checklist.itemCount == empty {
            text = "(No Items)"
        } else {
            text = uncheckedItems == empty ? "All Done" : "\(uncheckedItems) Remaining"
        }
        
        return text
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataModel.checklistCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        let checklist = dataModel.checklist(at: indexPath.row)
        configureCell(cell, for: checklist)
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // save the index of the checklist to restore later, if app gets terminated
        dataModel.indexOfSelectedChecklist = indexPath.row
        let checklist = dataModel.checklist(at: indexPath.row)
        performSegue(withIdentifier: "ShowChecklist", sender: checklist)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        dataModel.removeChecklist(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let checklist = dataModel.checklist(at: indexPath.row)
        performSegue(withIdentifier: "EditChecklist", sender: checklist)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChecklist" {
            let controller = segue.destination as! ChecklistViewController
            controller.checklist = sender as? Checklist
        } else if segue.identifier == "AddChecklist" {
            let controller = segue.destination as! ListDetailViewController
            controller.delegate = self
        } else if segue.identifier == "EditChecklist" {
            let controller = segue.destination as! ListDetailViewController
            controller.delegate = self
            controller.checklistToEdit = sender as? Checklist
        }
    }
}

// MARK: - List Detail View Controller Delegate

extension AllListsViewController: ListDetailViewControllerDelegate {
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        popViewController()
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist) {
        popViewController()
        
        _ = dataModel.add(checklist)
        dataModel.sortChecklists()
        tableView.reloadData()
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist) {
        popViewController()
        
        guard let index = dataModel.index(of: checklist) else { return }
        let indexPath = IndexPath(row: index, section: defaultSection)
        if let cell = tableView.cellForRow(at: indexPath) {
            configureCell(cell, for: checklist)
        }
    }
    
    private func popViewController() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Navigation Controller Delegate

extension AllListsViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController === self {
            // remove saved index, as the user navigated back to this view controller
            dataModel.indexOfSelectedChecklist = nil
        }
    }
}
