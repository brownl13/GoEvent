//
//  Vendor.swift
//  GoEvent
//
//  Created by Ziyin Zhang on 4/23/18.
//  Copyright © 2018 Logan. All rights reserved.
//

import Foundation
import RealmSwift

class Vendor: Object {
    @objc dynamic var name = ""
    @objc dynamic var cost = 0.0
    @objc dynamic var category = ""
}
