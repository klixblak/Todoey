//
//  Item.swift
//  Todoey
//
//  Created by Spencer Jones on 27/12/2018.
//  Copyright © 2018 Eyelite. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object
{
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}

