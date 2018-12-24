//
//  ViewController.swift
//  Todoey
//
//  Created by Spencer Jones on 20/12/2018.
//  Copyright © 2018 Eyelite. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController
{
    var itemArray = [Item]()
    let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

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
        cell.textLabel?.text = item.Title

        // Ternary operator ==>
        //
        // value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.Done ? .checkmark : .none
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        itemArray[indexPath.row].Done = !itemArray[indexPath.row].Done
        SaveItems()
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem)
    {
        var myNewItem = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in

                let newItem = Item()
                newItem.Title = myNewItem.text!
                self.itemArray.append(newItem)

                // we would like to make this persistant

                self.SaveItems()
                self.tableView.reloadData()
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
        let encoder = PropertyListEncoder()
        
        do
        {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }
        catch
        {
            print("Error encoding item array, \(error)")
        }

    }
    
    func LoadItems()
    {
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
    }
}

