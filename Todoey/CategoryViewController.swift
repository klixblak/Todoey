//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Spencer Jones on 27/12/2018.
//  Copyright © 2018 Eyelite. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController
{
    let realm = try! Realm()
    
    var categories: Results<Category>?

    override func viewDidLoad()
    {
        super.viewDidLoad()
        LoadCategories()
    }
    
    //basically this forces our table to always have at least 1 row.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let count = categories?.count
        {
            if count == 0
            {
                return 1
            }
            
            return count
        }
        // Nil coalescing Operator -> i.e. if the category array is empty (or nil) return 1
        return 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCategoryCell", for: indexPath)
        
        if let count = categories?.count
        {
            if count == 0
            {
                cell.textLabel?.text = "No Categories Entered"
            }
            else
            {
                cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Entered"
            }
        }

        return cell
    }
    
    func SaveCategories(category: Category)
    {
        do
        {
            try realm.write {
                realm.add(category)
            }
        }
        catch
        {
            print("Error encoding item array, \(error)")
        }

        
        self.tableView.reloadData()
    }

    func LoadCategories()
    {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem)
    {
        var myNewCategory = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in

            let newCategory = Category()
            newCategory.name = myNewCategory.text!
            self.SaveCategories(category: newCategory)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            myNewCategory = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - TableView Delegate Methods (don't do this yet)
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow
        {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
}
