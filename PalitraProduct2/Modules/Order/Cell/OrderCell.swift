//
//  OrderCell.swift
//  model.json
//
//  Created by Pol Krm on 23.06.22.
//

import UIKit

class OrderCell: UITableViewCell {
    @IBOutlet private weak var numberOrderLabel: UILabel!
    @IBOutlet private weak var orderDateLabel: UILabel!
    @IBOutlet private weak var clientNameLabel: UILabel!
    @IBOutlet private weak var partnerNameLabel: UILabel!
    @IBOutlet private weak var totalPriceLabel: UILabel!

    func setup(order: Order) {
        numberOrderLabel.text = "\(order.orderNumber ?? "")"
        orderDateLabel.text = "\(order.orderDate ?? Date())"
        clientNameLabel.text = order.client?.clientName
        partnerNameLabel.text = order.partner?.name
        
    }
}
