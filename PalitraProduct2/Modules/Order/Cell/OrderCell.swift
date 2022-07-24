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
    @IBOutlet private weak var totalCostWithoutFeeLabel: UILabel!
    @IBOutlet private weak var totalCostLabel: UILabel!
    @IBOutlet private weak var sendLabel: UILabel!

    func setup(order: Order) {
        if order.orderSent {
            sendLabel.text = "Отправлено"
            sendLabel.textColor = .green
        } else {
            sendLabel.text = "Не отправлено"
            sendLabel.textColor = .red
        }
        numberOrderLabel.text = "\(order.orderNumber ?? "")"
        orderDateLabel.text = "\(order.orderDate ?? Date())"
        clientNameLabel.text = order.client?.clientName
        partnerNameLabel.text = order.partner?.name
        totalCostWithoutFeeLabel.text = "с НДС: \(doubleInString(price: order.costWithFee)) руб."
        totalCostLabel.text = "без НДС: \(doubleInString(price: order.cost)) руб."
    }
    
    func doubleInString(price: Double) -> NSString {
        return NSString(format:"%.2f", price)
    }
}
