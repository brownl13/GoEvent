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
    var category: String!
    var typeTaken: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    
    //Hide Navigation Bar Again When user click Back button
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func addClicked(_ sender: Any) {
        budget = budget - cost
        //print(budget)
        if budget < 0 || budget < cost {
            let alert = UIAlertController(title: "Sorry!", message: "You are out of budget!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            do {
                let realm = try Realm()
                let vendor = realm.objects(Vendor.self).filter("name = '\(vendorName!)'")
                if vendor.count != 0 {
                    let alert = UIAlertController(title: "Opps!", message: "You already added this vendor!", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    budget = budget + cost
                    //print(vendor[0].category)
                } else {
                    let newVendor = Vendor(value: ["name" : vendorName, "cost": cost, "category": category])
                    for ven in savedVendors {
                        if ven.category == newVendor.category {
                                typeTaken = true
                        }
                    }
                    if typeTaken {
                        for ven in savedVendors {
                            if ven.category == newVendor.category {
                                try realm.write{
                                ven.name = newVendor.name
                                ven.cost = newVendor.cost
                                }
                                break
                            }
                        }
                    }
                    else {
                    try realm.write {
                        realm.add(newVendor)
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
        do {
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
        }
        
    }
}

