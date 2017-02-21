//
//  Item.swift
//  ShopME
//
//  Created by Steven Hernandez on 2/18/17.
//  Copyright © 2017 Steven Hernandez. All rights reserved.
//

import Foundation
import PhotosUI

class Item {
    var name: String
    var description: String
    var image: UIImage
    var priceCents: Int // never use doubles to store money
    
    var price: Double {
        get { return Double(self.priceCents / 100) }
        set { self.priceCents = Int(newValue * 100) }
    }
    
    init(_ name:String, _ description:String, _ price:Int, _ image:UIImage) {
        self.name = name
        self.description = description
        self.image = image
        self.priceCents = price
    }
    
    init(_ name:String, _ description:String, _ price:Double, _ image:UIImage) {
        self.name = name
        self.description = description
        self.image = image
        self.priceCents = 0
        self.price = price
    }
}
