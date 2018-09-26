//
//  Category.swift
//  Todoey
//
//  Created by Onur Hazar on 9/25/18.
//  Copyright © 2018 Hazar. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
