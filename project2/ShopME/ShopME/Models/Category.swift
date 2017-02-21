//
//  Category.swift
//  ShopME
//
//  Created by Steven Hernandez on 2/18/17.
//  Copyright © 2017 Steven Hernandez. All rights reserved.
//

import Foundation
import PhotosUI

class Category {
    var title: String
    var image: UIImage
    var items = [Item]()
    
    init(_ title: String, _ image: UIImage) {
        self.title = title
        self.image = image
    }
    
    func addItem(_ item: Item) {
        self.items.append(item)
    }
}
