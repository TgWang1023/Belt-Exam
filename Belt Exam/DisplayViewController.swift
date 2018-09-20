//
//  DisplayViewController.swift
//  Belt Exam
//
//  Created by Tiange Wang on 9/20/18.
//  Copyright © 2018 Tiange Wang. All rights reserved.
//

import UIKit
import CoreData

class DisplayViewController: UIViewController, EditFromDetailDelegate {
    
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    var fnTemp: String = ""
    var lnTemp: String = ""
    var numTemp: String = ""
    var idxTemp: Int?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let saveContext = (UIApplication.shared.delegate as! AppDelegate).saveContext
    var tableData: [Contact] = []
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "EditFromDetailSegue", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameLabel.text = fnTemp
        lastNameLabel.text = lnTemp
        numberLabel.text = numTemp
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditFromDetailSegue" {
            let dest = segue.destination as! AddEditViewController
            dest.delegate2 = self
            dest.fromDetails = true
            dest.fnTemp = fnTemp
            dest.lnTemp = lnTemp
            dest.numTemp = numTemp
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
    func saveButtonPressed(_ firstName: String, _ lastName: String, _ number: String) {
        fetchAllContacts()
        firstNameLabel.text = firstName
        lastNameLabel.text = lastName
        numberLabel.text = number
        tableData[idxTemp!].firstName = firstName
        tableData[idxTemp!].lastName = lastName
        tableData[idxTemp!].number = number
        saveContext()
        dismiss(animated: true, completion: nil)
    }
    
    func cancelButtonPressed() {
        dismiss(animated: true, completion: nil)
    }

}
