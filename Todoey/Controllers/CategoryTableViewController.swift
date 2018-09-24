//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Onur Hazar on 9/24/18.
//  Copyright © 2018 Hazar. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }

    //MARK: - TableView Datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let categoryItem = categoryArray[indexPath.row]
        cell.textLabel?.text = categoryItem.name
        
        return cell
    }
    
    //MARK: - TableView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "goToItems", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Data Manipulation methods
    
    func loadCategories() {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        do {
            try categoryArray = context.fetch(request)
        } catch {
            print("Error fetching category data from context \(error)")
        }
        
        tableView.reloadData()
    }
    
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error saving category to context \(error)")
        }
        
        tableView.reloadData()
    }
    
    //MARK: - Actions
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alertController = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let text = textField.text ?? "New Category"
            
            let newCategory = Category(context: self.context)
            newCategory.name = text
            
            self.categoryArray.append(newCategory)
            
            self.saveCategories()
        }
        
        alertController.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
}
