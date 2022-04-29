

import UIKit

class TodoListVC: UITableViewController {
    
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        let newItem2 = Item()
        let newItem3 = Item()
        
        newItem.title = "Eleven"
        newItem2.title = "Mike"
        newItem3.title = "Eagle"
        itemArray.append(newItem)
        itemArray.append(newItem2)
        itemArray.append(newItem3)
        
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//        }
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
        saveItems()
        
        return cell
    }

//MARK: TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
//MARK: - ADD NEW ITEMS
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        // This code create a pop-up notification.
        let alert = UIAlertController(title: "Add New Item to Todoey", message: "", preferredStyle: .alert)
        
        // This code line create a Button inside the alert in order to make an action with it.
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            //What will happen once the user clicks this button:
            
            let newItem = Item()
            newItem.title = textField.text!
            
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
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print(String(describing: error))
        }
        tableView.reloadData()
    }
}


