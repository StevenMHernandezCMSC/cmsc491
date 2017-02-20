//
//  Store.swift
//  ShopME
//
//  Created by Steven Hernandez on 2/18/17.
//  Copyright © 2017 Steven Hernandez. All rights reserved.
//

import Foundation
import PhotosUI

class Store {
    var items = [Item]()
    
    // load in some initial data, since we aren't using any database or anything of the sort
    init() {
        items.append(Item("Tomato, per lb", "On the vine", 245, #imageLiteral(resourceName: "grocery-1-tomatoes"), .grocery))
        items.append(Item("Banana, per lb", "Very durable(??)", 0.49, #imageLiteral(resourceName: "grocery-2-bananas"), .grocery))
        items.append(Item("Apple", "Gala apples", 140, #imageLiteral(resourceName: "grocery-3-gala"), .grocery))
        items.append(Item("Lettuce", "Green leaf lettuce", 3.19, #imageLiteral(resourceName: "grocery-4-lettuce"), .grocery))
        items.append(Item("Broccoli", "Bunch", 1.99, #imageLiteral(resourceName: "grocery-5-broccoli"), .grocery))
        items.append(Item("Milk", "One box, organic", 4.49, #imageLiteral(resourceName: "grocery-6-milk"), .grocery))
        items.append(Item("Lord of the Rings", "Never seen it.", 1.99, #imageLiteral(resourceName: "movies-2-lord-of-the-rings"), .movies))
    }
    
    init (items:[Item]) {
        self.items = items
    }
}
