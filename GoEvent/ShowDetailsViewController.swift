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
    
    
    var curEvent: Results<currentEvent>!
    var savedEvent: Results<event>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelName?.text = vendorName
        labelWebsite?.text = website
        textAbout?.text = about
        labelAddress?.text = address
        labelCost?.text = "Estimated Cost: $" + String(format: "%.2f", cost)
        //print(vendorName!)
        //view.backgroundColor = UIColor.white
        
        do {
            let realm = try Realm()
            curEvent = realm.objects(currentEvent.self)
            
            if let event1 = curEvent.first{
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
    }
    
    
    //Hide Navigation Bar Again When user click Back button
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func addClicked(_ sender: Any) {
        budget = budget - cost
        //print(budget)
        if budget < 0 {
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
                } else {
                    let newVendor = Vendor(value: ["name" : vendorName, "cost": cost])
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
        
    }
}
