//
//  Category.swift
//  Todoey
//
//  Created by Mostafa Mahmoud on 2/8/22.
//

import Foundation
import RealmSwift
class Category:Object
{
    @objc dynamic var name: String = ""
    @objc dynamic var colorName:String = ""
    let items = List<Item>()
}
