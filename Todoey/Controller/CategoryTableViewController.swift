//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Mostafa Mahmoud on 2/8/22.
//

import UIKit
import RealmSwift
import ChameleonFramework
class CategoryTableViewController: SwipeTableViewController {
    let realm = try! Realm()
    var message = UITextField()
    var categoryArray : Results<Category>?
    //MARK: - view will appear
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.scrollEdgeAppearance?.backgroundColor = UIColor(hexString: "1D9BF6")
        navigationController?.navigationBar.standardAppearance.backgroundColor = UIColor(hexString: "1D9BF6")
//        if let color = 
//        navigationController?.navigationBar.standardAppearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ]
//        UIColor(contrastingBlackOrWhiteColorOn:color, isFlat:true)
       if let color = UIColor(hexString: "1D9BF6")
        {
           navigationController?.navigationBar.standardAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(contrastingBlackOrWhiteColorOn:color, isFlat:true)!]
           navigationController?.navigationBar.standardAppearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(contrastingBlackOrWhiteColorOn:color, isFlat:true)!]
           navigationController?.navigationBar.scrollEdgeAppearance?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(contrastingBlackOrWhiteColorOn:color, isFlat:true)!]
           navigationController?.navigationBar.scrollEdgeAppearance?.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(contrastingBlackOrWhiteColorOn:color, isFlat:true)!]
           navigationItem.rightBarButtonItem?.tintColor = UIColor(contrastingBlackOrWhiteColorOn:color, isFlat:true)
       }
       

    }
    //MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
//        navigationController?.navigationBar.tintColor = UIColor.flatBlue()
        
    }
    //MARK: - view will disappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       
 
      

        
    }


    //MARK: - Button Pressed
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
       
        let alert = UIAlertController(title: "Please Enter a Category Name", message: "", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Create New Category"
            self.message=textField
        }
        let action = UIAlertAction(title: "Add", style: .default) { _ in
            if let message = self.message.text , message != ""
            {
                
                let newCategory = Category()
                newCategory.name = message
                newCategory.colorName = UIColor.randomFlat().hexValue()
                self.saveData(to: newCategory)
                
            }
            
            
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    //MARK: - Table view DataSource
    /// tableView Count
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    /// Archticture Of Cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories Add Yet"
        cell.backgroundColor = UIColor(hexString: categoryArray?[indexPath.row].colorName ?? "1D9BF6")
        cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn:cell.backgroundColor, isFlat:true)
        return cell
    }

    //MARK: - TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow 
        {

            destination.selectedCategory = categoryArray?[indexPath.row]
        }
    
        
    }
    //MARK: - Save Date
    func saveData(to category:Category)
    {
        do
        {
            try realm.write({
                realm.add(category)
            })
        }
        catch
        {
            print("error saving data in the category entity \(error)")
        }
        tableView.reloadData()
        
    }
    //MARK: - Load Data
    func loadData()
    {
        categoryArray = realm.objects(Category.self)
        tableView.reloadData()

    }
    override func updateModel(at indexPath: IndexPath) {
        if let item = self.categoryArray?[indexPath.row]
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
