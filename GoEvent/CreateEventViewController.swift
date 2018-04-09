//
//  CreateEventViewController.swift
//  GoEvent
//
//  Created by Logan on 3/28/18.
//  Copyright © 2018 Logan. All rights reserved.
//

import UIKit
import RealmSwift

class CreateEventViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var wedding: UIButton!
    @IBOutlet weak var generalParty: UIButton!
    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var guests: UITextField!
    @IBOutlet weak var budget: UITextField!
    
    var selection = ""
    var event1 = event()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.eventName.delegate = self
        self.guests.delegate = self
        self.budget.delegate = self
        
        let realm = try! Realm()
        try! realm.write {
            realm.delete(realm.objects(event.self))
        }
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func weddingSelected(_ sender: Any) {
        selection = "wedding"
        
        wedding.backgroundColor = UIColor.cyan
        generalParty.backgroundColor = UIColor.white
        
    }
    
    @IBAction func generalPartySelected(_ sender: Any) {
        selection = "general party"
        
        wedding.backgroundColor = UIColor.white
        generalParty.backgroundColor = UIColor.cyan
        
    }
    
    @IBAction func goClicked(_ sender: Any) {
        
        if selection == "" {
            
             let alert = UIAlertController(title: "Sorry!", message: "Please select an event type!", preferredStyle: UIAlertControllerStyle.alert)
            
             alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
             self.present(alert, animated: true, completion: nil)
            
        }
        
        else if (eventName.text?.isEmpty)! {
            
            let alert = UIAlertController(title: "Sorry!", message: "Please enter a name for your event!", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
        }
            
        else if (guests.text?.isEmpty)! {
            
            let alert = UIAlertController(title: "Sorry!", message: "Please enter the number of guests for your event!", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
        }
            
        else if (budget.text?.isEmpty)! {
            
            let alert = UIAlertController(title: "Sorry!", message: "Please enter a budget for your event!", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
        else {
            
            event1.budget = budget.text!
            event1.eventName = eventName.text!
            event1.eventType = selection
            event1.numGuests = guests.text!
            
            do {
                let realm = try Realm()
                try realm.write() {
                    realm.add(event1)
                }
                
            }
            catch {
                print(error.localizedDescription)
            }
        
            if (selection == "wedding")
            {
                let myWC = self.storyboard?.instantiateViewController(withIdentifier: "startWeddingViewController") as! startWeddingViewController
                
                self.navigationController?.pushViewController(myWC, animated: true)
            }
            
            else if (selection == "general party")
            {
                let myGC = self.storyboard?.instantiateViewController(withIdentifier: "startGeneralPartyViewController") as! startGeneralPartyViewController
               
                self.navigationController?.pushViewController(myGC, animated: true)
            }
        }
        
    }
    
    
    
}
