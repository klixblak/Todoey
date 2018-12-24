//
//  Item.swift
//  Todoey
//
//  Created by Spencer Jones on 24/12/2018.
//  Copyright © 2018 Eyelite. All rights reserved.
//

import Foundation

class Item: Encodable, Decodable
{
    var Title : String = ""
    var Done : Bool = false
}
