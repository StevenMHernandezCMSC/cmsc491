//
//  ViewController.swift
//  ShopME
//
//  Created by Steven Hernandez on 2/18/17.
//  Copyright © 2017 Steven Hernandez. All rights reserved.
//

import UIKit

// TODO: handle global variables better
var store = Store()
var user = User()

class MenuController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return store.categories.count + 2
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
            cell.title.text = store.categories[indexPath.item - 2].title
            cell.icon.image = store.categories[indexPath.item - 2].image
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            performSegue(withIdentifier: "ordersShow", sender: self)
        } else if indexPath.item == 1 {
            performSegue(withIdentifier: "currentOrderShow", sender: self)
        } else {
            performSegue(withIdentifier: "showCategory", sender: store.categories[indexPath.item - 2])
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCategory"{
            if let destinationVC = segue.destination as? CategoryController {
                destinationVC.category = sender as? Category
            }
        }
    }
}
