//
//  AllListsViewController.swift
//  Checklists
//
//  Created by Mohsin Ali Ayub on 30.08.24.
//

import UIKit

class AllListsViewController: UITableViewController {
    
    private let cellIdentifier = "ChecklistCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        var configuration = cell.defaultContentConfiguration()
        configuration.text = "List \(indexPath.row)"
        
        cell.contentConfiguration = configuration
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowChecklist", sender: nil)
    }
    
}
