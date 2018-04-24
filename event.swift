//
//  event.swift
//  
//
//  Created by Logan on 4/4/18.
//

import Foundation
import RealmSwift

class event: Object {
    @objc dynamic var eventName = ""
    @objc dynamic var eventType = ""
    @objc dynamic var numGuests = ""
    @objc dynamic var budget = ""
    @objc dynamic var email = ""
    @objc dynamic var username = ""
    @objc dynamic var pcost = 0.0
    @objc dynamic var pname = ""
    @objc dynamic var bcost = 0.0
    @objc dynamic var bname = ""
    @objc dynamic var fcost = 0.0
    @objc dynamic var fname = ""
    @objc dynamic var dcost = 0.0
    @objc dynamic var dname = ""
    @objc dynamic var vcost = 0.0
    @objc dynamic var vname = ""
    
}
