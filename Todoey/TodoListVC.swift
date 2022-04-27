

import UIKit

class TodoListVC: UITableViewController {
    
    var itemArray = ["Mike", "Eleven", "Mark"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
//MARK: - ADD NEW ITEMS
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        // Notification will pop-up
        let alert = UIAlertController(title: "Add New Item to Todoey", message: "", preferredStyle: .alert)
        
        // Button you gonna press once you're done with writing your new to-do
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            //What will happen once the user clicks this button:
            
            if textField.text != nil {
                self.itemArray.append(textField.text!)
                self.tableView.reloadData()
            }
        }
        
        alert.addTextField { alertTextFiled in
            alertTextFiled.placeholder = "Create new item"
            textField = alertTextFiled
        }
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    
    
}
