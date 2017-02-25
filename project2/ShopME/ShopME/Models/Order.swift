//
//  Cart.swift
//  ShopME
//
//  Created by Steven Hernandez on 2/18/17.
//  Copyright © 2017 Steven Hernandez. All rights reserved.
//

import Foundation

class Order {
    var items = [String: [OrderItem]]()
    var purchaseDate:Date?
    
    func getItemCount() -> Int {
        var total = 0
        
        for category in items {
            for orderItem in category.value {
                total += orderItem.quantity
            }
        }
        
        return total
    }
    
    func getCategoryName(_ index: Int) -> String {
        return Array(user.currentOrder.items.keys)[index]
    }
    
    func getItemsInCategory(_ index: Int) -> [OrderItem]? {
        let categoryName = self.getCategoryName(index)
        
        return self.getItemsInCategory(categoryName)
    }
    
    func getItemsInCategory(_ categoryName: String) -> [OrderItem]? {
        return user.currentOrder.items[categoryName]
    }
    
    func getTotal() -> Int {
        var total = 0
        
        for category in items {
            for orderItem in category.value {
                total += orderItem.getCost()
            }
        }

        return total
    }
    
    func totalFormatted() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: Double(self.getTotal()) / 100))!
    }
    
    func addItem(_ newItem: Item, categoryName: String) {
        if let c = items[categoryName] {
            for orderItem in c {
                // TODO: use ids instead of names
                if orderItem.item.name == newItem.name {
                    orderItem.quantity += 1
                    return
                }
            }
        } else {
            items[categoryName] = [OrderItem]()
        }
        
        items[categoryName]!.append(OrderItem(item: newItem))
    }
    
    func increment(category: String, at index: Int) {
        items[category]?[index].quantity += 1
    }
    
    func decrement(category: String, at index: Int) {
        items[category]?[index].quantity -= 1
        
        if (items[category]?[index].quantity)! <= 0 {
            items[category]?.remove(at: index)
            
            if ((items[category]?.count)! <= 0) {
                items.removeValue(forKey: category)
            }
        }
    }
}
