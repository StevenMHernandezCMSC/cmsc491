//
//  OrderItem.swift
//  ShopME
//
//  Created by Steven Hernandez on 2/18/17.
//  Copyright © 2017 Steven Hernandez. All rights reserved.
//

import Foundation

class OrderItem {
    var item:Item
    var quantity = 1
    
    init (item: Item) {
        self.item = item
    }
    
    func getCost() -> Int {
        return item.priceCents * quantity
    }
}
