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
    }
    
    func placeOrder() {
        currentOrder.purchaseDate = Date()
        previousOrders.append(currentOrder)
        currentOrder = Order()
    }
}
