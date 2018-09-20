//
//  ViewController.swift
//  Belt Exam
//
//  Created by Tiange Wang on 9/20/18.
//  Copyright © 2018 Tiange Wang. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, AddItemDelegate {

    let sections: [String] = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let saveContext = (UIApplication.shared.delegate as! AppDelegate).saveContext
    var tableData: [Contact] = []
    
    var fnTemp: String = ""
    var lnTemp: String = ""
    var numTemp: String = ""
    var ipTemp: IndexPath?
    var idxTemp: Int = 0
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "AddSegue", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        fetchAllContacts()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchAllContacts()
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddSegue" {
            let dest = segue.destination as! AddEditViewController
            dest.delegate = self
            dest.fromDetails = false
        } else if segue.identifier == "EditSegue" {
            let dest = segue.destination as! AddEditViewController
            dest.delegate = self
            dest.fnTemp = fnTemp
            dest.lnTemp = lnTemp
            dest.numTemp = numTemp
            dest.ipTemp = ipTemp
            dest.fromDetails = false
        } else if segue.identifier == "DisplaySegue" {
            let dest = segue.destination as! DisplayViewController
            dest.fnTemp = fnTemp
            dest.lnTemp = lnTemp
            dest.numTemp = numTemp
            dest.idxTemp = idxTemp
        }
    }
    
    func fetchAllContacts() {
        let contactRequest:NSFetchRequest<Contact> = Contact.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "firstName", ascending: true)
        do {
            contactRequest.sortDescriptors = [sortDescriptor]
            tableData = try context.fetch(contactRequest)
        } catch {
            print(error)
        }
    }
    
    // Delegate
    func saveButtonPressed(_ firstName: String, _ lastName: String, _ number: String, at indexPath: IndexPath?) {
        if let ip = indexPath {
            tableData[ip.row].firstName = firstName
            tableData[ip.row].lastName = lastName
            tableData[ip.row].number = number
            saveContext()
        } else {
            let newContact = Contact(context: context)
            newContact.firstName = firstName
            newContact.lastName = lastName
            newContact.number = number
            saveContext()
            tableData.append(newContact)
        }
        fetchAllContacts()
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    func cancelButtonPressed() {
        dismiss(animated: true, completion: nil)
    }

}
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Contact")!
        cell.textLabel?.text = tableData[indexPath.row].firstName! + " " + tableData[indexPath.row].lastName!
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        fnTemp = tableData[indexPath.row].firstName!
        lnTemp = tableData[indexPath.row].lastName!
        numTemp = tableData[indexPath.row].number!
        idxTemp = indexPath.row
        performSegue(withIdentifier: "DisplaySegue", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.context.delete(self.tableData[indexPath.row])
            self.saveContext()
            self.tableData.remove(at: indexPath.row)
            self.fetchAllContacts()
            self.tableView.reloadData()
        }
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            self.ipTemp = indexPath
            self.fnTemp = self.tableData[indexPath.row].firstName!
            self.lnTemp = self.tableData[indexPath.row].lastName!
            self.numTemp = self.tableData[indexPath.row].number!
            self.performSegue(withIdentifier: "EditSegue", sender: indexPath)
        }
        edit.backgroundColor = UIColor.blue
        return [delete, edit]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 26
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sections
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section] as? String
    }
    
}

