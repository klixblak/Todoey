//
//  Category.swift
//  Todoey
//
//  Created by Spencer Jones on 27/12/2018.
//  Copyright © 2018 Eyelite. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object
{
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
