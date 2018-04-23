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
    
    var savedEvent: Results<event>!
    var category: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelName?.text = vendorName
        labelWebsite?.text = website
        textAbout?.text = about
        labelAddress?.text = address
        labelCost?.text = "Estimated Cost: $" + String(format: "%.2f", cost)
        print(vendorName!)
        //view.backgroundColor = UIColor.white
        
        do {
            let realm = try Realm()
            savedEvent = realm.objects(event.self)
            
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
                    try realm.write {
                        realm.add(newVendor)
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
            savedEvent = realm.objects(event.self)
            
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

