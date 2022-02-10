//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Mostafa Mahmoud on 2/9/22.
//

import UIKit
import SwipeCellKit
class SwipeTableViewController: UITableViewController,SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    //MARK: - table view Datasource
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        return cell
    }
    //MARK: - Swipe Delegate

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            print("delete cell")
            self.updateModel(at: indexPath)
//           
            
            
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-Icon")

        return [deleteAction]
    }
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    func updateModel (at indexPath:IndexPath)
    {
        //update our data model
    }
    
 

}
