//
//  OrdersController.swift
//  ShopME
//
//  Created by Steven Hernandez on 2/18/17.
//  Copyright © 2017 Steven Hernandez. All rights reserved.
//

import UIKit

class OrdersController: UITableViewController {
    
    var editMode = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.renderRightBarButtonItem();
    }
    
    func toggleEditMode() {
        self.editMode = !self.editMode;
        
        self.renderRightBarButtonItem();
        
        // hide delete button if it happens to be showing
        self.tableView!.reloadData()
    }
    
    func renderRightBarButtonItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: self.editMode ? "Done" : "Edit", style: .plain, target: self, action: #selector(toggleEditMode))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.previousOrders.count > 10 ? 10 : user.previousOrders.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath) as! OrderTableCell

        let order = user.previousOrders[indexPath.item]

        cell.orderInfoLabel?.text = "\(order.getItemCount()) items (\(order.totalFormatted()))"

        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MMM/dd, E, h:mm a"
        cell.dateLabel?.text = dateformatter.string(from: order.purchaseDate!)

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return editMode
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            user.previousOrders.remove(at: indexPath.item)
            tableView.reloadData()
        }
    }
}
