//
//  startWeddingViewController.swift
//  GoEvent
//
//  Created by Logan on 3/28/18.
//  Copyright © 2018 Logan. All rights reserved.
//

import UIKit
import RealmSwift
import MessageUI

class startWeddingViewController: UIViewController, MFMailComposeViewControllerDelegate {
    @IBOutlet weak var budget: UITextField!
    
    @IBOutlet weak var pCost: UITextField!
    @IBOutlet weak var pName: UITextField!
    @IBOutlet weak var bCost: UITextField!
    @IBOutlet weak var bName: UITextField!
    @IBOutlet weak var fCost: UITextField!
    @IBOutlet weak var fName: UITextField!
    @IBOutlet weak var dCost: UITextField!
    @IBOutlet weak var dName: UITextField!
    @IBOutlet weak var vCost: UITextField!
    @IBOutlet weak var vName: UITextField!
    
    var user2 = user()
    var savedUser: Results<user>!
    var event2 = event()
    var savedEvent: Results<event>!
    var current: Results<currentEvent>!
    var cEvent = currentEvent()
    var clickedEvent = event()
    var vendors: Results<Vendor>!
    var currentVendor = Vendor()
    var finished = false
    var vendors2 = [Vendor]()
    var remainingBudget = 0.0
    var startingBudget = ""
    var endingBudget = ""
    var message = ""
    var message2 = ""
    var message3 = ""
    var message4 = ""
    var message5 = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            let realm = try Realm()
            savedUser = realm.objects(user.self)
            savedEvent = realm.objects(event.self)
            current = realm.objects(currentEvent.self)
            vendors = realm.objects(Vendor.self)
            for v in vendors {
                vendors2.append(v)
            }
            
            
        }
        catch {
            print(error.localizedDescription)
        }
        
        cEvent = current[0]
        user2 = savedUser[0]
        remainingBudget = Double(cEvent.budget)!
        
        let numberFormater = NumberFormatter()
        numberFormater.numberStyle = NumberFormatter.Style.currency
        startingBudget = numberFormater.string(from: NSNumber(value: remainingBudget))!
        
        if cEvent.pname == "" {
            
        }
        else {
        pName.text = cEvent.pname
        pCost.text = numberFormater.string(from: NSNumber(value: cEvent.pcost))
        remainingBudget = remainingBudget - cEvent.pcost
        }
        
        if cEvent.vname == "" {
            
        }
        else{
        vName.text = cEvent.vname
        vCost.text = numberFormater.string(from: NSNumber(value: cEvent.vcost))
        remainingBudget = remainingBudget - cEvent.vcost
        }
        
        if cEvent.bname == "" {
            
        }
        else {
        bName.text = cEvent.bname
        bCost.text = numberFormater.string(from: NSNumber(value: cEvent.bcost))
        remainingBudget = remainingBudget - cEvent.bcost
        }
        
        if cEvent.fname == "" {
            
        }
        else {
        fName.text = cEvent.fname
        fCost.text = numberFormater.string(from: NSNumber(value: cEvent.fcost))
        remainingBudget = remainingBudget - cEvent.fcost
        }
        
        if cEvent.dname == "" {
            
        }
        else {
        dName.text = cEvent.dname
        dCost.text = numberFormater.string(from: NSNumber(value: cEvent.dcost))
        remainingBudget = remainingBudget - cEvent.dcost
        }
        
        do {
            let realm = try Realm()
            for e in savedEvent {
                if e.eventName == cEvent.eventName && e.username == cEvent.username {
                    try realm.write {
                        e.pcost = cEvent.pcost
                        e.pname = cEvent.pname
                        e.bcost = cEvent.bcost
                        e.bname = cEvent.bname
                        e.fcost = cEvent.fcost
                        e.fname = cEvent.fname
                        e.dcost = cEvent.dcost
                        e.dname = cEvent.dname
                        e.vcost = cEvent.vcost
                        e.vname = cEvent.vname
                    }
                }
            }
        }
        catch {
            print(error.localizedDescription)
        }
        
       
        
        let formattedBudget = numberFormater.string(from: NSNumber(value: remainingBudget))
        endingBudget = formattedBudget!
        budget.text = formattedBudget
    
    vendors2.removeAll()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.navigationItem.hidesBackButton = true
        
        do {
            let realm = try Realm()
            savedUser = realm.objects(user.self)
            savedEvent = realm.objects(event.self)
            current = realm.objects(currentEvent.self)
            vendors = realm.objects(Vendor.self)
            for v in vendors {
                vendors2.append(v)
            }
            
            
        }
        catch {
            print(error.localizedDescription)
        }
        
        cEvent = current[0]
        user2 = savedUser[0]
        remainingBudget = Double(cEvent.budget)!
        let numberFormater = NumberFormatter()
        numberFormater.numberStyle = NumberFormatter.Style.currency
        startingBudget = numberFormater.string(from: NSNumber(value: remainingBudget))!
        
        if cEvent.pname == "" {
            
        }
        else {
            pName.text = cEvent.pname
            pCost.text = numberFormater.string(from: NSNumber(value: cEvent.pcost))
            remainingBudget = remainingBudget - cEvent.pcost
        }
        
        if cEvent.vname == "" {
            
        }
        else{
            vName.text = cEvent.vname
            vCost.text = numberFormater.string(from: NSNumber(value: cEvent.vcost))
            remainingBudget = remainingBudget - cEvent.vcost
        }
        
        if cEvent.bname == "" {
            
        }
        else {
            bName.text = cEvent.bname
            bCost.text = numberFormater.string(from: NSNumber(value: cEvent.bcost))
            remainingBudget = remainingBudget - cEvent.bcost
        }
        
        if cEvent.fname == "" {
            
        }
        else {
            fName.text = cEvent.fname
            fCost.text = numberFormater.string(from: NSNumber(value: cEvent.fcost))
            remainingBudget = remainingBudget - cEvent.fcost
        }
        
        if cEvent.dname == "" {
            
        }
        else {
            dName.text = cEvent.dname
            dCost.text = numberFormater.string(from: NSNumber(value: cEvent.dcost))
            remainingBudget = remainingBudget - cEvent.dcost
        }
        
        
        do {
            let realm = try Realm()
            for e in savedEvent {
                if e.eventName == cEvent.eventName && e.username == cEvent.username {
                    try realm.write {
                        e.pcost = cEvent.pcost
                        e.pname = cEvent.pname
                        e.bcost = cEvent.bcost
                        e.bname = cEvent.bname
                        e.fcost = cEvent.fcost
                        e.fname = cEvent.fname
                        e.dcost = cEvent.dcost
                        e.dname = cEvent.dname
                        e.vcost = cEvent.vcost
                        e.vname = cEvent.vname
                    }
                }
            }
        }
        catch {
            print(error.localizedDescription)
        }
        
        
        
        let formattedBudget = numberFormater.string(from: NSNumber(value: remainingBudget))
        budget.text = formattedBudget
        endingBudget = formattedBudget!
        
        vendors2.removeAll()
    }
    
    
    @IBAction func finishClicked(_ sender: Any) {
        
        sendEmail()
        
    }
    func sendEmail() {
        
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        // Configure the fields of the interface.
        composeVC.setToRecipients([user2.email])
        composeVC.setSubject("Your event details")
        
        message = "Thank you " + user2.name + " for using GoEvent to plan your event. Below is the details of your event:\n\n" + "Event Name: " + cEvent.eventName + "\nEvent Type: " + cEvent.eventType
        message.append("Number of Guests")
        message.append(event2.numGuests)
        message.append("\nStarting Budget: ")
        message.append(startingBudget)
        message.append("\nRemaining Budget: ")
        message.append(String(remainingBudget))
        message.append("\n\nPhotgrapher Name: ")
        message.append(cEvent.pname)
        message.append("\nPhotgrapher Cost: ")
        message.append(String(cEvent.pcost))
        message.append("\n\nBeauty Name: ")
        message.append(cEvent.bname)
        message.append("\nBeauty Cost: ")
        message.append(String(cEvent.bcost))
        message.append("\n\nFlorist Name: ")
        message.append(cEvent.fname)
        message.append("\nFlorist Cost: ")
        message.append(String(cEvent.fcost))
        message.append("\n\nDJ Name: ")
        message.append(cEvent.dname)
        message.append("\nDJ Cost: ")
        message.append(String(cEvent.dcost))
        message.append("\n\nReception Name: ")
        message.append(cEvent.vname)
        message.append("\nReception Cost: ")
        message.append(String(cEvent.vcost))
        
        composeVC.setMessageBody(message, isHTML: false)
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        switch result {
        case .cancelled:
            break
        case .saved:
            finished = true
        case .sent:
            finished = true
        case .failed:
            break
            
        }
        
        controller.dismiss(animated: true, completion: nil)
        
        if(finished){
            let mySC = self.storyboard?.instantiateViewController(withIdentifier: "CreateEventViewController") as! CreateEventViewController
            self.navigationController?.popViewController(animated: false)
            
            self.navigationController?.pushViewController(mySC, animated: true)
        }
    }
    
}
