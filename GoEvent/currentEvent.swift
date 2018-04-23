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
    
}
