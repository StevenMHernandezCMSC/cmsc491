//
//  CartController.swift
//  ShopME
//
//  Created by Steven Hernandez on 2/18/17.
//  Copyright © 2017 Steven Hernandez. All rights reserved.
//

import UIKit

class CartController: UITableViewController {
    @IBOutlet weak var priceTextLabel: UILabel!
    @IBOutlet weak var quantityTextLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Your Cart"
        
        self.loadCartInformation()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(goHome))
    }
    
    func goHome() {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    func reload() {
        self.tableView.reloadData()
        self.loadCartInformation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // TODO: category count
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
    
    func loadCartInformation() {
        self.priceTextLabel.text = user.currentOrder.totalFormatted()
        self.quantityTextLabel.text = String(user.currentOrder.getItemCount())
    }

    @IBAction func decreaseQuantityPressed(_ sender: Any) {
        user.currentOrder.decrement(at: (sender as! UIButton).tag)
        self.reload()
    }

    @IBAction func increaseQuantityPressed(_ sender: Any) {
        user.currentOrder.increment(at: (sender as! UIButton).tag)
        self.reload()
    }

    @IBAction func emptyCart(_ sender: Any) {
        user.currentOrder = Order()
        self.reload()
    }

    @IBAction func makePurchase(_ sender: Any) {
        if (user.currentOrder.getItemCount() == 0) {
            self.errorAlert("There are no items in your cart!")
        } else {
            let alert = UIAlertController(title: "Ready to Buy?", message: "Are you sure you've picked up everything?", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Place Order", style: .default, handler: self.placeOrderConfirmed)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(action)
            alert.addAction(cancel)
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    func placeOrderConfirmed(action: UIAlertAction) {
        user.placeOrder()
        
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    func errorAlert(_ message: String) {
        let errorAlert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        errorAlert.addAction(action)
        
        present(errorAlert, animated: true, completion: nil)
    }
}
