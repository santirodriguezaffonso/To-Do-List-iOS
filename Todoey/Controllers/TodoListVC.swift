

import UIKit

class TodoListVC: UITableViewController {
    
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
//MARK: - Model Manipulation Methods

    // First Step - Encode the new data and save it in our own plist.file
    func saveItems() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array\(String(describing: error))")
        }
        tableView.reloadData()
    }
    
    // Second Step - Decode the saved data from the plist.file, pointing out your Model.swift as data type.
    func loadItem() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding items\(String(describing: error))")
            }
        }
    }
}
