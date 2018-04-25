//
//  ShowDetailsViewController.swift
//  GoEvent
//
//  Created by Ziyin Zhang on 4/22/18.
//  Copyright © 2018 Logan. All rights reserved.
//

import UIKit
import RealmSwift


class ShowDetailsViewController: UIViewController {
    
    
    @IBOutlet weak var labelName: UILabel?
    @IBOutlet weak var labelWebsite: UILabel?
    @IBOutlet weak var textAbout: UITextView!
    @IBOutlet weak var labelAddress: UILabel?
    @IBOutlet weak var labelCost: UILabel!
    
    var vendorName: String!
    var website: String!
    var about: String!
    var address: String!
    var cost: Double!
    var budget: Double!
    var savedUser: Results<user>!
    var savedVendors: Results<Vendor>!
    var savedEvent: Results<currentEvent>!
    var curEvent = currentEvent()
    var category: String!
    var typeTaken: Bool!
    var vendorTaken: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vendorTaken = false
        typeTaken = false
        labelName?.text = vendorName
        labelWebsite?.text = website
        textAbout?.text = about
        labelAddress?.text = address
        labelCost?.text = "Estimated Cost: $" + String(format: "%.2f", cost)
        print(vendorName!)
        //view.backgroundColor = UIColor.white
        
        do {
            let realm = try Realm()
            savedEvent = realm.objects(currentEvent.self)
            savedVendors = realm.objects(Vendor.self)
           
            if let event1 = savedEvent.first{
                print(event1.budget)
                budget = Double(event1.budget)
                print(budget)
            } else {
                budget = 0.0
            }
        }
        catch {
            print(error.localizedDescription)
        }
        print(category)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.hidesBackButton = true
       
    }
   
    @IBAction func addClicked(_ sender: Any) {
        budget = budget - cost
        curEvent = savedEvent[0]
        let newVendor = Vendor(value: ["name" : vendorName, "cost": cost, "category": category])
        //print(budget)
        if newVendor.category == "Photographer"
        {
            if newVendor.name == curEvent.pname {
                vendorTaken = true
            }
           budget = budget + curEvent.pcost - curEvent.bcost - curEvent.fcost -
            curEvent.dcost - curEvent.vcost
        }
        else if newVendor.category == "Beauty"
        {
            if newVendor.name == curEvent.bname {
                vendorTaken = true
            }
            budget = budget - curEvent.pcost + curEvent.bcost - curEvent.fcost -
                curEvent.dcost - curEvent.vcost
        }
        else if newVendor.category == "Florist"
        {
            if newVendor.name == curEvent.fname {
                vendorTaken = true
            }
            budget = budget - curEvent.pcost - curEvent.bcost + curEvent.fcost -
                curEvent.dcost - curEvent.vcost
        }
        else if newVendor.category == "DJ"
        {
            if newVendor.name == curEvent.dname {
                vendorTaken = true
            }
            budget = budget - curEvent.pcost - curEvent.bcost - curEvent.fcost +
                curEvent.dcost - curEvent.vcost
        }
        else if newVendor.category == "Reception"
        {
            if newVendor.name == curEvent.vname {
                vendorTaken = true
            }
            budget = budget - curEvent.pcost - curEvent.bcost - curEvent.fcost -
                curEvent.dcost + curEvent.vcost
        }
        if budget < 0 || budget < cost {
            let alert = UIAlertController(title: "Sorry!", message: "You are out of budget!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            do {
                let realm = try Realm()
                _ = realm.objects(Vendor.self).filter("name = '\(vendorName!)'")
                if vendorTaken {
                    let alert = UIAlertController(title: "Opps!", message: "You already added this vendor!", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    budget = budget + cost
                    //print(vendor[0].category)
                } else {
                    
                    if newVendor.category == "Photographer"
                    {
                        try realm.write {
                            curEvent.pname = newVendor.name
                            curEvent.pcost = newVendor.cost
                        }
                    }
                    else if newVendor.category == "Beauty"
                    {
                        try realm.write {
                            curEvent.bname = newVendor.name
                            curEvent.bcost = newVendor.cost
                        }
                    }
                    else if newVendor.category == "Florist"
                    {
                        try realm.write {
                            curEvent.fname = newVendor.name
                            curEvent.fcost = newVendor.cost
                        }
                    }
                    else if newVendor.category == "DJ"
                    {
                        try realm.write {
                            curEvent.dname = newVendor.name
                            curEvent.dcost = newVendor.cost
                        }
                    }
                    else if newVendor.category == "Reception"
                    {
                        try realm.write {
                            curEvent.vname = newVendor.name
                            curEvent.vcost = newVendor.cost
                        }
                    }
                    
                    let alert = UIAlertController(title: "Done!", message: "This vendor is added!", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
        
        //update the budget
       /*do {
            let realm = try Realm()
            savedEvent = realm.objects(currentEvent.self)
            
            if let event = savedEvent.first{
                try realm.write {
                    event.budget = String(budget)
                    print(event.budget)
                }
            }
        }
        catch {
            print(error.localizedDescription)
        } */
        
    }
}

