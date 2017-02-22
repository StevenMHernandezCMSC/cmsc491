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
    
    func addItem(_ newItem: Item) {
        for orderItem in items {
            // TODO: use ids instead of names
            if orderItem.item.name == newItem.name {
                orderItem.quantity += 1
                print("found \(orderItem.quantity)")
                return
            }
        }
        
        items.append(OrderItem(item: newItem))
    }
}
