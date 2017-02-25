//
//  User.swift
//  ShopME
//
//  Created by Steven Hernandez on 2/18/17.
//  Copyright © 2017 Steven Hernandez. All rights reserved.
//

import Foundation

class User {
    var previousOrders = [Order]()
    var currentOrder:Order

    init () {
        self.currentOrder = Order()

        // TODO: remove
//        self.currentOrder.addItem(store.categories[0].items[0])
        
//        let exampleOrder = Order();
//        exampleOrder.addItem(store.categories[0].items[0])
//        exampleOrder.purchaseDate = Date()
        
//        self.previousOrders.append(exampleOrder)
    }
    
    func placeOrder() {
        currentOrder.purchaseDate = Date()
        previousOrders.insert(currentOrder, at: 0)
        currentOrder = Order()
    }
}
