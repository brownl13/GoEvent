//
//  startGeneralPartyViewController.swift
//  GoEvent
//
//  Created by Logan on 3/28/18.
//  Copyright © 2018 Logan. All rights reserved.
//

import UIKit
import RealmSwift
import MessageUI

class startGeneralPartyViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    
    var user2 = user()
    var savedUser: Results<user>!
    var event2 = event()
    var savedEvent: Results<event>!
    
    var sent = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            let realm = try Realm()
            savedUser = realm.objects(user.self)
            savedEvent = realm.objects(event.self)
            
        }
        catch {
            print(error.localizedDescription)
        }
        user2 = savedUser[0]
        event2 = savedEvent[0]
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
        composeVC.setMessageBody("Thank you " + user2.name + " for using GoEvent to plan your event. Below is the details of your event:\n\n" + "Event Name: " + event2.eventName + "\nEvent Type: " + event2.eventType + "\nNumber of Guests: " + event2.numGuests + "\nBudget: " + event2.budget, isHTML: false)
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        switch result {
        case .cancelled:
            sent = false
        case .saved:
            sent = false
        case .sent:
            break
        case .failed:
            sent = false
            
        }
        
        controller.dismiss(animated: true, completion: nil)
        
        if(sent){
            let alert = UIAlertController(title: "Success!", message: "Email has been sent!", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
}
