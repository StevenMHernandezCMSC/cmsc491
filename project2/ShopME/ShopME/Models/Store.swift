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
        let clothing = Category("Clothing", #imageLiteral(resourceName: "category-4-clothing"))
        let movies = Category("Movies", #imageLiteral(resourceName: "category-5-movies"))
        let gardening = Category("Gardening", #imageLiteral(resourceName: "category-6-garden"))
        let electronics = Category("Electronics", #imageLiteral(resourceName: "category-7-electronics"))
        let books = Category("Books", #imageLiteral(resourceName: "category-8-books"))
        let appliances = Category("Appliances", #imageLiteral(resourceName: "category-9-appliances"))
        let toys = Category("Toys", #imageLiteral(resourceName: "category-10-toys"))

        grocery.addItem(Item("Tomato, per lb", "On the vine", 245, #imageLiteral(resourceName: "grocery-1-tomatoes")))
        grocery.addItem(Item("Banana, per lb", "Very durable(??)", 0.49, #imageLiteral(resourceName: "grocery-2-bananas")))
        grocery.addItem(Item("Apple", "Gala apples", 140, #imageLiteral(resourceName: "grocery-3-gala")))
        grocery.addItem(Item("Lettuce", "Green\nleaf\nlettuce", 3.19, #imageLiteral(resourceName: "grocery-4-lettuce")))
        grocery.addItem(Item("Broccoli", "Bunch", 1.99, #imageLiteral(resourceName: "grocery-5-broccoli")))
        grocery.addItem(Item("Milk", "One box, organic", 4.49, #imageLiteral(resourceName: "grocery-6-milk")))

        clothing.addItem(Item("Men's Suit", "It is a suit", 999.9, #imageLiteral(resourceName: "menssuit")))
        clothing.addItem(Item("Women's Suit", "This one is a suit too", 999, #imageLiteral(resourceName: "womenssuit")))
        clothing.addItem(Item("Straw Hat", "Backed/With Ribbon", 8.98, #imageLiteral(resourceName: "hat")))
        clothing.addItem(Item("(The) hat", "This is it", 12.54, #imageLiteral(resourceName: "the-hat")))
        clothing.addItem(Item("Tie", "tie it.", 12.97, #imageLiteral(resourceName: "tie")))
        
        movies.addItem(Item("Lord of the Rings", "Never seen it.", 1.99, #imageLiteral(resourceName: "movies-2-lord-of-the-rings")))
        movies.addItem(Item("Plan 9", "from outerspace", 1.99, #imageLiteral(resourceName: "plan9")))
        movies.addItem(Item("9 Deaths of the ninja", "9 is a good number", 1.99, #imageLiteral(resourceName: "9ninjadeaths")))
        movies.addItem(Item("Christiane", "I think David Bowie was in this movie", 1.99, #imageLiteral(resourceName: "christiane")))
        movies.addItem(Item("Up from the depths", "Ocean Movie", 1.99, #imageLiteral(resourceName: "upfromthedepths")))

        gardening.addItem(Item("Red Yellow Flowers", "They are nice looking I guess", 6.99, #imageLiteral(resourceName: "redflowers")))
        gardening.addItem(Item("Alpaca", "Alpaca my bags...", 1500.00, #imageLiteral(resourceName: "important-alpaca")))
        gardening.addItem(Item("Yellow Flowers", "Not much red here", 5.99, #imageLiteral(resourceName: "yellowflowers")))
        gardening.addItem(Item("Pink Flowers", "Pink", 5.96, #imageLiteral(resourceName: "pinkflowers")))
        gardening.addItem(Item("Snowy Garden Gnome", "Clean that snow!", 16.96, #imageLiteral(resourceName: "gardengnome")))

        electronics.addItem(Item("Arduino", "SMD version", 24.99, #imageLiteral(resourceName: "arduino")))
        electronics.addItem(Item("Adafruit Metro", "Using the same ATMEGA328", 18.99, #imageLiteral(resourceName: "adafruitmetro")))
        electronics.addItem(Item("Raspberry Pi", "", 35.99, #imageLiteral(resourceName: "raspberrypi")))
        electronics.addItem(Item("38126_B101", "On sale", 69.80, #imageLiteral(resourceName: "38126_B101_sale_800x356")))
        electronics.addItem(Item("Soldering Iron", "Weller", 59.99, #imageLiteral(resourceName: "solderingiron")))
        
        books.addItem(Item("Old Books", "Look how fancy", 21.99, #imageLiteral(resourceName: "oldbooks")))
        books.addItem(Item("Stack of old books", "Lots of them", 89.97, #imageLiteral(resourceName: "stackofoldbooks")))
        books.addItem(Item("Assorted Notebooks", "Assorted Flavors", 12.99, #imageLiteral(resourceName: "notebooks")))
        books.addItem(Item("Stack of Books", "Delivered by drone\nDropped off at the nearest field", 14.95, #imageLiteral(resourceName: "stackofoldbooks")))
        books.addItem(Item("Celtic Book", "Not just a 3d model this time", 4.99, #imageLiteral(resourceName: "celticbook")))

        appliances.addItem(Item("Sauce Pan", "For Cooking", 20.99, #imageLiteral(resourceName: "saucepan")))
        appliances.addItem(Item("Coffee Maker", "Brew it up", 25.99, #imageLiteral(resourceName: "coffemaker")))
        appliances.addItem(Item("Hand Mixer", "Mix it up with this mixer", 9.95, #imageLiteral(resourceName: "mixer")))
        appliances.addItem(Item("Vacuum", "Clean it up with", 149.99, #imageLiteral(resourceName: "vacuum")))
        appliances.addItem(Item("Toaster", "Toast it up", 19.99, #imageLiteral(resourceName: "toaster")))
        appliances.addItem(Item("Bigger Toaster", "Toast it up bigger", 34.99, #imageLiteral(resourceName: "biggertoaster")))

        toys.addItem(Item("Toy Car", "Blue", 3.49, #imageLiteral(resourceName: "toycar")))
        toys.addItem(Item("Cooler Toy Car", "Looks like batman", 9.79, #imageLiteral(resourceName: "coolertoycar")))
        toys.addItem(Item("Toy Dinosaurs", "2 pack", 5.95, #imageLiteral(resourceName: "toydinosaurs")))
        toys.addItem(Item("This thing...", "Large eye balls", 6.96, #imageLiteral(resourceName: "green-eyeballs-toy")))
        toys.addItem(Item("Pink Dachshund", "Pink", 8.99, #imageLiteral(resourceName: "pink-dog-toy")))
        toys.addItem(Item("Pink Pig Bank", "Pink", 9.99, #imageLiteral(resourceName: "pink-pig-toy")))
        
        categories.append(grocery)
        categories.append(clothing)
        categories.append(movies)
        categories.append(gardening)
        categories.append(electronics)
        categories.append(books)
        categories.append(appliances)
        categories.append(toys)
    }
    
    init (categories:[Category]) {
        self.categories = categories
    }
}
