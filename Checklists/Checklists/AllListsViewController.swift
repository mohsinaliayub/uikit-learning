//
//  AllListsViewController.swift
//  Checklists
//
//  Created by Mohsin Ali Ayub on 30.08.24.
//

import UIKit

class AllListsViewController: UITableViewController {
    
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

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        let list = lists[indexPath.row]
        
        var configuration = cell.defaultContentConfiguration()
        configuration.text = list.name
        cell.contentConfiguration = configuration
        cell.accessoryType = .detailDisclosureButton
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowChecklist", sender: nil)
    }
    
}
