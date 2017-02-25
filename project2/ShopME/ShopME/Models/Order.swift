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
    var purchaseDate:Date?
    
    func getItemCount() -> Int {
        var total = 0
        
        items.forEach { (orderItem) in
            total += orderItem.quantity
        }
        
        return total
    }
    
    func getTotal() -> Int {
        var total = 0

        items.forEach { (orderItem) in
            total += orderItem.getCost()
        }

        return total
    }
    
    func totalFormatted() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: Double(self.getTotal()) / 100))!
    }
    
    func addItem(_ newItem: Item) {
        for orderItem in items {
            // TODO: use ids instead of names
            if orderItem.item.name == newItem.name {
                orderItem.quantity += 1
                return
            }
        }
        
        items.append(OrderItem(item: newItem))
    }
    
    func increment(at index: Int) {
        items[index].quantity += 1
    }
    
    func decrement(at index: Int) {
        items[index].quantity -= 1
        
        if items[index].quantity <= 0 {
            items.remove(at: index)
        }
    }
}
