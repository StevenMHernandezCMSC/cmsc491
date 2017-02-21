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
    var categories = [Category]()
    
    // load in some initial data, since we aren't using any database or anything of the sort
    init() {
        let grocery = Category("Grocery", #imageLiteral(resourceName: "category-3-grocery"))
        let movies = Category("Movies", #imageLiteral(resourceName: "category-5-movies"))

        grocery.addItem(Item("Tomato, per lb", "On the vine", 245, #imageLiteral(resourceName: "grocery-1-tomatoes")))
        grocery.addItem(Item("Banana, per lb", "Very durable(??)", 0.49, #imageLiteral(resourceName: "grocery-2-bananas")))
        grocery.addItem(Item("Apple", "Gala apples", 140, #imageLiteral(resourceName: "grocery-3-gala")))
        grocery.addItem(Item("Lettuce", "Green leaf lettuce", 3.19, #imageLiteral(resourceName: "grocery-4-lettuce")))
        grocery.addItem(Item("Broccoli", "Bunch", 1.99, #imageLiteral(resourceName: "grocery-5-broccoli")))
        grocery.addItem(Item("Milk", "One box, organic", 4.49, #imageLiteral(resourceName: "grocery-6-milk")))
        movies.addItem(Item("Lord of the Rings", "Never seen it.", 1.99, #imageLiteral(resourceName: "movies-2-lord-of-the-rings")))
        
        categories.append(grocery)
        categories.append(movies)
    }
    
    init (categories:[Category]) {
        self.categories = categories
    }
}
