//
//  ViewController.swift
//  ShopME
//
//  Created by Steven Hernandez on 2/18/17.
//  Copyright © 2017 Steven Hernandez. All rights reserved.
//

import UIKit

class MenuController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    // TODO: this will need to share between views
    var store = Store()
    var user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.store.categories.count + 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! MenuItemCell

        if indexPath.item == 0 {
            cell.title.text = "Recent Orders"
            cell.icon.image = #imageLiteral(resourceName: "category-1-recent")
        } else if indexPath.item == 1 {
            cell.title.text = "Cart"
            cell.icon.image = #imageLiteral(resourceName: "category-2-cart")
        } else {
            cell.title.text = self.store.categories[indexPath.item - 2].title
            cell.icon.image = self.store.categories[indexPath.item - 2].image
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            // TODO: jump to "recent orders page"
        } else if indexPath.item == 1 {
            // TODO: jump to "cart page"
        } else {
            // TODO: jump to "categories page" with category: (indexPath.item - 2)
        }
    }
}
