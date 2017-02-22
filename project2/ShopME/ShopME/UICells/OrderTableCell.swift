//
//  OrderTableCell.swift
//  ShopME
//
//  Created by Steven Hernandez on 2/21/17.
//  Copyright © 2017 Steven Hernandez. All rights reserved.
//

import UIKit

class OrderTableCell: UITableViewCell {
    @IBOutlet weak var orderInfoLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
