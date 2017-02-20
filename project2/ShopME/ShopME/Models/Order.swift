//
//  Cart.swift
//  ShopME
//
//  Created by Steven Hernandez on 2/18/17.
//  Copyright © 2017 Steven Hernandez. All rights reserved.
//

import Foundation

class Order {
    var items = [OrderItem]()
    var purchaseDate:NSDate?
    
    func getItemCount() -> Int {
        return self.items.count
    }
    
    func getTotal() -> Double {
        var total = 0

        items.forEach { (orderItem) in
            total += orderItem.getCost()
        }

        return Double(total / 100)
    }
}
