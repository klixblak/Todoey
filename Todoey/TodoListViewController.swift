//
//  ViewController.swift
//  Todoey
//
//  Created by Spencer Jones on 20/12/2018.
//  Copyright © 2018 Eyelite. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController
{
    var itemArray = [Item]()
    var selectedCategory : Category? {
        didSet {
            LoadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad()
    {
        super.viewDidLoad()
        //LoadItems()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title

        // Ternary operator ==>
        //
        // value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        SaveItems()

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem)
    {
        var myNewItem = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in

            let newItem = Item(context: self.context)
            newItem.title = myNewItem.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)

            self.SaveItems()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            myNewItem = alertTextField
        }
            
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func SaveItems()
    {
        
        do
        {
            try context.save()
        }
        catch
        {
            print("Error encoding item array, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func LoadItems(with request: NSFetchRequest<Item> = Item.fetchRequest())//, predicate: NSPredicate? = nil)
    {
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = request.predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }
        else
        {
            request.predicate = categoryPredicate
        }
        
        do
        {
            itemArray = try context.fetch(request)
        }
        catch
        {
            print ("Error fetching data \(error)")
        }
        tableView.reloadData()
    }
    
}

// MARK - Extension functions for the search bar
extension TodoListViewController: UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        // it is worth downloading the predicate cheat sheet from academy.realm.io
        // note the [cd] says ignore case and weird characters above letters e.g. German umlout.
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        LoadItems(with: request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if searchBar.text?.count == 0
        {
            LoadItems()
            
            DispatchQueue.main.async
            {
                searchBar.resignFirstResponder()
            }
        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        LoadItems()
    }
    

}

