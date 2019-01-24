//
//  ViewController.swift
//  Familink
//
//  Created by formation9 on 23/01/2019.
//  Copyright © 2019 CubaLibre. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var login: UITextField!
    @IBOutlet weak var password: UITextField!
    private var token : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func onTapButton(_ sender: Any) {
        
        APIClient.instance.getToken(login: self.login.text ?? "", password: self.password.text ?? "", onSuccess: { (token) in
            self.token = token
            print("Token is ok")
        }) { (error) in
            print(error)
        }
    }
    
    @IBAction func onGetListeButton(_ sender: Any) {
        APIClient.instance.getContactList(token: self.token, onSuccess: { (contacts) in
            print(contacts)
        }) { (error) in
            print(error)
        }
    }
    
    @IBAction func onAddButton(_ sender: Any) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        
        let c = Contact(context: context)
        c.firstName = "aaaaaaa"
        c.lastName = "jhghg"
        c.phone = "0618948899"
        c.email = "gfgf@hf"
        c.gravatar = "http://aaaaa"
        c.profile = "FAMILLE"
        c.isEmergencyUser = true
        c.isFamilinkUser = false
        
        
        APIClient.instance.addContact(token: self.token, contact: c, onSuccess: { (success) in
            print(success)
        }) { (error) in
            print(error)
        }
    }
    
    
    @IBAction func onDeleteButton(_ sender: Any) {
        APIClient.instance.deleteContact(token: self.token, contactId: "5c49ca6565ecd90866845a03", onSuccess: { (success) in
            print(success)
        }) { (error) in
            print(error)
        }
    }
    
    
    @IBAction func onUpdateButton(_ sender: Any) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        
        let c = Contact(context: context)
        c.contactId = "5c49c8bf65ecd90866845a01"
        c.firstName = "Update Kevyn"
        c.lastName = "Update"
        c.phone = "0618728899"
        c.email = "update@hf"
        c.gravatar = "http://update"
        c.profile = "FAMILLE"
        c.isEmergencyUser = true
        c.isFamilinkUser = false
        
        APIClient.instance.updateContact(token: self.token, contact: c, onSuccess: { (success) in
            print(success)
        }) { (error) in
            print(error)
        }
        
    }
}
