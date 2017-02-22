//
//  CartController.swift
//  ShopME
//
//  Created by Steven Hernandez on 2/18/17.
//  Copyright © 2017 Steven Hernandez. All rights reserved.
//

import UIKit

class CartController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.currentOrder.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderItemCell", for: indexPath) as! OrderItemTableCell
        
        let orderItem = user.currentOrder.items[indexPath.item]
        
        cell.titleLabel?.text = orderItem.item.name
        cell.priceLabel?.text = orderItem.priceFormatted()
        cell.quantityLabel.text = String(orderItem.quantity)
        cell.decreaseButton.tag = indexPath.item
        cell.increaseButton.tag = indexPath.item
        
        return cell
    }

    @IBAction func decreaseQuantityPressed(_ sender: Any) {
        user.currentOrder.decrement(at: (sender as! UIButton).tag)
        self.tableView.reloadData()
    }

    @IBAction func increaseQuantityPressed(_ sender: Any) {
        user.currentOrder.increment(at: (sender as! UIButton).tag)
        self.tableView.reloadData()
    }
}
