//
//  IconPickerViewController.swift
//  Checklists
//
//  Created by Mohsin Ali Ayub on 02.09.24.
//

import UIKit

protocol IconPickerViewControllerDelegate: AnyObject {
    func iconPicker(_ controller: IconPickerViewController, didPick iconName: String)
}

class IconPickerViewController: UITableViewController {
    private let icons = [
        "No Icon", "Appointments", "Birthdays", "Chores",
        "Drinks", "Folder", "Groceries", "Inbox", "Photos", "Trips"
    ]
    
    weak var delegate: IconPickerViewControllerDelegate?
    
    // MARK: Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        icons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IconCell", for: indexPath)
        
        let iconName = icons[indexPath.row]
        
        var configuration = cell.defaultContentConfiguration()
        configuration.image = UIImage(named: iconName)
        configuration.text = iconName
        cell.contentConfiguration = configuration
        
        return cell
    }
    
    // MARK: Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let iconName = icons[indexPath.row]
        delegate?.iconPicker(self, didPick: iconName)
    }
}
