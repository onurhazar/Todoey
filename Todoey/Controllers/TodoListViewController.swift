//
//  ViewController.swift
//  Todoey
//
//  Created by Onur Hazar on 9/20/18.
//  Copyright © 2018 Hazar. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
//    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath!)
        
        loadItems()
        
//        let newItem = Item()
//        newItem.title = "Buy Tomatoes"
//        itemArray.append(newItem)
//
//        let newItem2 = Item()
//        newItem2.title = "Buy Eggs"
//        itemArray.append(newItem2)
//
//        for index in 0...50 {
//            let newItem3 = Item()
//            newItem3.title = "Buy Drinks \(index)"
//            itemArray.append(newItem3)
//        }
        
//        if let items = defaults.value(forKey: "TodoListArray") as? [String] {
//            itemArray = items
//        }
    }

    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath : IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }

    //MARK - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let itemToSelect = itemArray[indexPath.row]
        
        //how to delete from core data
//        context.delete(itemToSelect)
//        itemArray.remove(at: indexPath.row)
        
        itemToSelect.done = !itemToSelect.done

        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = cell?.accessoryType == .checkmark ? .none : .checkmark
        
        saveItems()
        
        //refresh if you delete data
//        self.tableView.reloadData()
    }
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        textField.placeholder = "New Item"
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let text = textField.text ?? "New Item"
            
            let newItem = Item(context: self.context)
            newItem.title = text
            
            self.itemArray.append(newItem)
            
            print("Item is added: \(text)")
            
            self.saveItems()
            
//            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK - Data operations for prespecified plist
    
    func saveItems() {
       
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    func loadItems(){
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
}

