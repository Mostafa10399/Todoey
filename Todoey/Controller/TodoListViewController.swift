//
//  ViewController.swift
//  Todoey
//
//  Created by Mostafa Mahmoud on 2/4/22.
//

import UIKit
import RealmSwift
import ChameleonFramework
import SwiftUI
class TodoListViewController: SwipeTableViewController {
    @IBOutlet weak var addButton: UIBarButtonItem!
    var message=UITextField()
    var realm = try! Realm()
    @IBOutlet weak var searchBarIB: UISearchBar!
    var selectedCategory:Category?
    {
        didSet{
            loadItems()
        }
    }
    var itemArray:Results<Item>?
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    //MARK: - View will appear
    override func viewWillAppear(_ animated: Bool) {
      
        if let name = selectedCategory?.name {
            navigationItem.title = name
        }
        navigationItem.backBarButtonItem?.title = "back"
       
        if let color = selectedCategory?.colorName ,let hexColor = UIColor(hexString: color)
        {
            navigationController?.navigationBar.scrollEdgeAppearance?.backgroundColor = UIColor(hexString: color)
            navigationController?.navigationBar.standardAppearance.backgroundColor = UIColor(hexString: color)
            
            navigationController?.navigationBar.standardAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor(contrastingBlackOrWhiteColorOn:hexColor, isFlat:true)!]
            navigationController?.navigationBar.standardAppearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor(contrastingBlackOrWhiteColorOn:hexColor, isFlat:true)!]
            navigationController?.navigationBar.scrollEdgeAppearance?.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor(contrastingBlackOrWhiteColorOn:hexColor, isFlat:true)!]
            navigationController?.navigationBar.scrollEdgeAppearance?.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor(contrastingBlackOrWhiteColorOn:hexColor, isFlat:true)!]
            
            
            
            
            searchBarIB.barTintColor = UIColor(hexString: color)

//            navigationController?.navigationBar.tintColor = UIColor(hexString: color)
            addButton.tintColor = UIColor(contrastingBlackOrWhiteColorOn:hexColor, isFlat:true)
            navigationController?.navigationBar.tintColor = UIColor(contrastingBlackOrWhiteColorOn:hexColor, isFlat:true)
            
          
            
            
            
          
            
            
        }
        
    }
    //MARK: - View Did load
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        navigationItem.backButtonTitle = "Back"
        if let color = UIColor(hexString: selectedCategory?.colorName){
            searchBarIB.searchTextField.textColor = UIColor(contrastingBlackOrWhiteColorOn:color, isFlat:true)
            

        }
        let gestur = UITapGestureRecognizer(target: self, action: #selector (TabOnTitle))
        navigationItem.titleView?.addGestureRecognizer(gestur)
       
     
       
    }
    @objc func TabOnTitle()
    {
        searchBarIB.resignFirstResponder()
    }
    
    
    //MARK: -  Table View DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = itemArray?[indexPath.row], let colorRows = selectedCategory?.colorName
        {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ?.checkmark :.none
            
            
            
            if let color = UIColor(hexString: colorRows)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(itemArray!.count))
            {
                cell.backgroundColor = color
                cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn:color, isFlat:true)
            }
           
        }
        else
        {
            cell.textLabel?.text = "There Is No Items To Show"
        }
        return cell
        
    }
    //MARK: -  Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBarIB.resignFirstResponder()
        if let item = itemArray?[indexPath.row]
        {
            do
            {
                try realm.write({
                                item.done = !item.done
                            })

            }
            catch
            {
                print("error updating \(error)")
            }
            
        }
        self.tableView.reloadData()
    }
    
    //MARK: - Add Button Pressed
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        searchBarIB.resignFirstResponder()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            self.message = alertTextField
        }
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            
            if let message = self.message.text , message != ""
            {
                if let currentCategory = self.selectedCategory
                {
                    do {
                    try self.realm.write({
                        let newItem = Item()
                        newItem.title = message
                        newItem.createdDate = Date()
                        currentCategory.items.append(newItem)
                        self.realm.add(newItem)
                    })
                    }
                    catch
                    {
                        print("error saving \(error)")
                    }
                   
                }

                
               
                
                
                
            }
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    //MARK: - Save Data Method
    func saveData(to data:Item){
        do
        {
            try realm.write {
                realm.add(data)
            }
            
        }
        catch
        {
            print("error while saving data \(error)")
        }
        self.tableView.reloadData()
    }

    //MARK: - Load Items
    func loadItems()
    {
        itemArray = selectedCategory?.items.sorted(byKeyPath: "createdDate", ascending: true)
        tableView.reloadData()


    }
    override func updateModel(at indexPath: IndexPath) {
        if let item = itemArray?[indexPath.row]
                   {
                       do
                       {
                           try self.realm.write {
                               self.realm.delete(item)
                               
                           }
                           
       
                       }
                       catch
                       {
                           print("errer deleting item \(error)")
                       }
       
                   }
       
      
    }

}

extension TodoListViewController:UISearchBarDelegate
{
    //MARK: - Search bar Button Clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        
        
        itemArray = itemArray?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "createdDate", ascending: true)
        tableView.reloadData()
    }
//
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0
        {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }
    
   

}

