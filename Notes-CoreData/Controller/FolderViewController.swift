//
//  ViewController.swift
//  Notes-CoreData
//
//  Created by Anofienam Isioma on 10/04/2019.
//  Copyright © 2019 com.chuck. All rights reserved.
//

import UIKit
import CoreData


class FolderViewController: UIViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var folderArray = [Folder]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = .lightGray
        navigationController?.navigationBar.tintColor = .black
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
//        clearDB()
        fetchData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! NotesViewController
        
        if let selectedCell = (view.subviews.first as! UITableView).indexPathForSelectedRow{
            destinationVC.selectedFolder = folderArray[selectedCell.row]
        }
    }
    
    @IBAction func addNewFolder(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Folder", message: "", preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            let folder = Folder(context: self.context)
            folder.name = textField.text
            if folder.name != ""{
                self.folderArray.append(folder)
                self.saveData()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addTextField { (field) in
            field.placeholder = "Add new Folder"
            textField = field
           
        }
        
        alert.addAction(cancelAction)
        alert.addAction(addAction)
       
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveData(){
        do{
            try context.save()
        }catch {
            print("An error occured while saving the data: \(error)")
        }
        reloadTableView()
    }
    
    func fetchData(){
        let request : NSFetchRequest<Folder> =  Folder.fetchRequest()
        
        do{
           folderArray = try context.fetch(request)
        }catch{
            print("Error fetching request: \(error)")
        }
        reloadTableView()
    }
    
    func clearDB(){
    //       let deleteRequest : NSFetchRequest<Note> = Note.fetchRequest()
        let deleteReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        
        let delete = NSBatchDeleteRequest(fetchRequest: deleteReq)
        do{
            try context.execute(delete)
            try context.save()
            print("#################### DELETED")
        
        }catch{
            print("Error deleting request \(error)")
        }
    }

}


extension FolderViewController: UITableViewDelegate, UITableViewDataSource{
    
    func reloadTableView(){
        let tableView = view.subviews.first as! UITableView
        tableView.reloadData()
        tableView.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folderArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notesCell", for: indexPath)
        
        let folder = folderArray[indexPath.row]
        cell.textLabel?.text = folder.name
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToNotes", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
            self.context.delete(self.folderArray[indexPath.row])
            self.folderArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.saveData()
        }
        
        let textField = UITextField()
        
        let edit = UITableViewRowAction(style: .default, title: "Rename") { (action, indexPath) in
            
            let alert = UIAlertController(title: "Rename Folder", message: "", preferredStyle: .alert)
            
            let addAction = UIAlertAction(title: "Save", style: .default, handler: { (action) in
                
                if textField.text != "" {
                    self.folderArray[indexPath.row].setValue(textField.text, forKey: "name")
                    self.saveData()
                    
                }
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addTextField(configurationHandler: { (field) in
                field.placeholder = "Enter new name"
                textField.text = field.text
            })
            
            alert.addAction(cancelAction)
            alert.addAction(addAction)
            
            self.present(alert, animated: true,completion: nil)
        }
        
        edit.backgroundColor = .lightGray
        
        return [delete, edit]
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .normal, title: "Edit") { (action, view, success:(Bool) -> Void) in
            
            print("leading type pressed ")
            success(true)
        }
        
        action.backgroundColor = .lightGray
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    
}

