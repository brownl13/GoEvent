//
//  currentEvent.swift
//  GoEvent
//
//  Created by Logan on 4/23/18.
//  Copyright © 2018 Logan. All rights reserved.
//

import Foundation
import RealmSwift

class currentEvent: Object {
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
