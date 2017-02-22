//
//  CategoryController.swift
//  ShopME
//
//  Created by Steven Hernandez on 2/18/17.
//  Copyright © 2017 Steven Hernandez. All rights reserved.
//

import UIKit

class CategoryController: UITableViewController {
    
    var category: Category?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = category!.title
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category!.items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryTableCell
        
        let item = category!.items[indexPath.item]
        
        cell.itemImage?.image = item.image
        cell.title?.text = item.name
        cell.descriptionLabel?.text = item.description
        cell.price?.text = item.priceFormatted()
        cell.addButton.tag = indexPath.item

        return cell
    }

    @IBAction func addItemPressed(_ sender: Any) {
        user.currentOrder.addItem(category!.items[(sender as! UIButton).tag])
    }
}
