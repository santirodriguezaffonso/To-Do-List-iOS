

import UIKit
import CoreData

class ItemsVC: SwipeTableVC {
    
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet{
            loadItem()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }
    
    //    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //        return
    //    }
    
//MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        let items = itemArray[indexPath.row]
        
        cell.textLabel?.text = items.title
        cell.accessoryType = items.done == true ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
//MARK: - Add New Items
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        // This code create a pop-up notification.
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        // This code line create a Button inside the alert in order to make an action with it.
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            //What will happen once the user clicks this button:
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!.capitalized
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            if textField.text != nil {
                self.itemArray.append(newItem)
                self.saveItems()
                
                self.tableView.reloadData()
            }
        }
        
        alert.addTextField { alertTextFiled in
            alertTextFiled.placeholder = "Create new item"
            textField = alertTextFiled
        }
        alert.addAction(action)
        present(alert, animated: true)
        alert.addAction(cancelAction)
    }
    
//MARK: - Model Manipulation Methods
    
    // First Step - Encode the new data and save it in our own plist.file
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context\(error)")
        }
    }
    
    // Second Step - Decode the saved data from the plist.file, pointing out your Model.swift as data type.
    func loadItem(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from Context\(error)")
        }
        tableView.reloadData()
    }
    
    // This override the function from SwipeTableVC
    override func updateModel(at indexPath: IndexPath) {
        self.context.delete(self.itemArray[indexPath.row])
        self.itemArray.remove(at: indexPath.row)
        
        self.saveItems()
    }
}

//MARK: - Search Bar Methods

extension ItemsVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request = Item.fetchRequest()
        
        // This create a predicate that filter the query
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        // This sort the tableview in alphabetical order by "title"
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItem(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItem()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
