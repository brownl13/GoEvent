//
//  user.swift
//  GoEvent
//
//  Created by Logan on 4/4/18.
//  Copyright © 2018 Logan. All rights reserved.
//

import Foundation
import RealmSwift

class user: Object {
    @objc dynamic var name = ""
    @objc dynamic var email = ""
    @objc dynamic var password = ""
    
}

