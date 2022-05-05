

import UIKit
import CoreData

class TodoListVC: UITableViewController {
    
    var itemArray = [Item]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadItem()
    }
    
    //    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //        return
    //    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let items = itemArray[indexPath.row]
        
        cell.textLabel?.text = items.title
        cell.accessoryType = items.done == true ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: - Add New Items
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        // This code create a pop-up notification.
        let alert = UIAlertController(title: "Add New Item to Todoey", message: "", preferredStyle: .alert)
        
        // This code line create a Button inside the alert in order to make an action with it.
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            //What will happen once the user clicks this button:
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            
            if textField.text != nil {
                self.itemArray.append(newItem)
                self.saveItems()
            }
        }
        
        alert.addTextField { alertTextFiled in
            alertTextFiled.placeholder = "Create new item"
            textField = alertTextFiled
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    //MARK: - Model Manipulation Methods
    
    // First Step - Encode the new data and save it in our own plist.file
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context\(error)")
        }
        tableView.reloadData()
    }
    
    // Second Step - Decode the saved data from the plist.file, pointing out your Model.swift as data type.
    func loadItem(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from Context\(error)")
        }
        tableView.reloadData()
    }
}

//MARK: - Search Bar Methods
extension TodoListVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request = Item.fetchRequest()
        
        // This create a predicate that filter the query
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        // This sort the tableview in alphabetical order by "title"
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItem(with: request)
    }
}
