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
    
}
