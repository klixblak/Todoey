//
//  ViewController.swift
//  Todoey
//
//  Created by Spencer Jones on 20/12/2018.
//  Copyright © 2018 Eyelite. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController, UISearchBarDelegate
{
    var itemArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad()
    {
        super.viewDidLoad()
        LoadItems()
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
        
/*        let encoder = PropertyListEncoder()
        
        do
        {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }
        catch
        {
            print("Error encoding item array, \(error)")
        }
*/
    }
    
    func LoadItems()
    {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do
        {
            itemArray = try context.fetch(request)
        }
        catch
        {
            print ("Error fetching data \(error)")
        }
        
        /*
        if let data = try? Data(contentsOf: dataFilePath!)
        {
            let decoder = PropertyListDecoder()
            do
            {
                itemArray = try decoder.decode([Item].self, from: data)
            }
            catch
            {
                print("error \(error)")
            }
        }
         */
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        
    }
}

