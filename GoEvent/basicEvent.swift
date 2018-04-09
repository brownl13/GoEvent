//
//  basicEvent.swift
//  GoEvent
//
//  Created by Logan on 4/4/18.
//  Copyright © 2018 Logan. All rights reserved.
//

import Foundation
import RealmSwift

class basicEvent: Object {
    @objc dynamic var eventName = ""
    @objc dynamic var eventType = ""
    @objc dynamic var numGuests = ""
    @objc dynamic var budget = ""
    
}
