//
//  Item.swift
//  Todoey
//
//  Created by Mostafa Mahmoud on 2/8/22.
//

import Foundation
import RealmSwift

class Item :Object
{
    @objc dynamic var title:String=""
    @objc dynamic var done:Bool=false
    @objc dynamic var colorName:String = ""
    @objc dynamic var createdDate : Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
    
}
