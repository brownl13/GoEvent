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
    var curEvent = currentEvent()
    var curEvent2 = currentEvent()
    var event1 = event()
    var event2 = event()
    var savedEvent: Results<event>!
    var savedUser: Results<user>!
    var user1 = user()
    var curEvents: Results<currentEvent>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.eventName.delegate = self
        self.guests.delegate = self
        self.budget.delegate = self
        
       /* let realm = try! Realm()
        try! realm.write {
            realm.delete(realm.objects(event.self))
        } */
        
        self.navigationItem.setHidesBackButton(true, animated:true);
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.eventName.delegate = self
        self.guests.delegate = self
        self.budget.delegate = self
        
       /* let realm = try! Realm()
        try! realm.write {
            realm.delete(realm.objects(event.self))
        } */
        
        wedding.backgroundColor = UIColor.white
        generalParty.backgroundColor = UIColor.white
        eventName.text = ""
        guests.text = ""
        budget.text = ""
        
        self.navigationItem.setHidesBackButton(true, animated:true);
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
         
            
            
            
         
            do{
            
                let realm = try Realm()
                curEvents = realm.objects(currentEvent.self)
                savedUser = realm.objects(user.self)
                user1 = savedUser[0]
                
                
            if let curEvent = curEvents.first{
                try realm.write(){
                    curEvent.budget = budget.text!
                    curEvent.eventName = eventName.text!
                    curEvent.eventType = selection
                    curEvent.numGuests = guests.text!
                    curEvent.email = user1.email
                    curEvent.username = user1.name
                    event2.budget = budget.text!
                    event2.eventName = eventName.text!
                    event2.eventType = selection
                    event2.numGuests = guests.text!
                    event2.email = user1.email
                    event2.username = user1.name
                    realm.add(event2)
                }
            }
                
            else {
               
                try realm.write(){
                    curEvent2.budget = budget.text!
                    curEvent2.eventName = eventName.text!
                    curEvent2.eventType = selection
                    curEvent2.numGuests = guests.text!
                    curEvent2.email = user1.email
                    curEvent2.username = user1.name
                    event2.budget = budget.text!
                    event2.eventName = eventName.text!
                    event2.eventType = selection
                    event2.numGuests = guests.text!
                    event2.email = user1.email
                    event2.username = user1.name
                    realm.add(event2)
                    realm.add(curEvent2)
                }
            }
            }
            
            catch {
                print(error.localizedDescription)
            }

            
            
           
        }
            
        
        }
        
    }
    
    
    

