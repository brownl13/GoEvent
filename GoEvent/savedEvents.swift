//
//  savedEvents.swift
//  GoEvent
//
//  Created by Logan on 4/20/18.
//  Copyright © 2018 Logan. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class savedEvents: UITableViewController {
    var savedEvent: Results<event>!
    var savedUser: Results<user>!
    var current: Results<currentEvent>!
    var current2 = currentEvent()
    var current3 = currentEvent()
    var events = [event]()
    
    
    @IBOutlet var eventTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        events.removeAll()
        
        
        do {
        
        let realm = try Realm()
        savedEvent = realm.objects(event.self)
        savedUser = realm.objects(user.self)
        
        for e in savedEvent {
            
            if e.username == savedUser[0].name {
                events.append(e)
                
            }
        
        }
        }
        catch {
            print(error.localizedDescription)
        }
        
        self.eventTable.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.hidesBackButton = true
        self.eventTable.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if events.isEmpty {
            return 0
       
        }
        return events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        
        let item = events[indexPath.row]
        cell.textLabel?.text = item.eventName
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        
        let indexPath = tableView.indexPathForSelectedRow
        
        //getting the current cell from the index path
        
        let item = events[(indexPath?.row)!]
        
        do{
            
            let realm = try Realm()
            current = realm.objects(currentEvent.self)
           
            
            if let current2 = current.first{
                try realm.write(){
                    current2.budget = item.budget
                    current2.eventName = item.eventName
                    current2.eventType = item.eventType
                    current2.numGuests = item.numGuests
                    current2.email = item.email
                    current2.username = item.username
            }
            }
                
            else {
                
                try realm.write(){
                    current3.budget = item.budget
                    current3.eventName = item.eventName
                    current3.eventType = item.eventType
                    current3.numGuests = item.numGuests
                    current3.email = item.email
                    current3.username = item.username
                    realm.add(current3)
                }
            }
        }
            
        catch {
            print(error.localizedDescription)
        }
        
        
        
        if item.eventType == "wedding" {
            let mySC = self.storyboard?.instantiateViewController(withIdentifier: "weddingPlanned") as! weddingPlanned
            mySC.eventClicked = item
            navigationController?.pushViewController(mySC, animated: true)
        }
        
        else if item.eventType == "general party" {
            let mySC = self.storyboard?.instantiateViewController(withIdentifier: "startGeneralPartyViewController") as! startGeneralPartyViewController
            
            navigationController?.pushViewController(mySC, animated: true)
        }
        
        
        
        
       
        
        
        
    }
    
    
}
