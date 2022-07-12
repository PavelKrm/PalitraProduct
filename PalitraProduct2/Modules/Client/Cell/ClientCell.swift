//
//  CloentCell.swift
//  model.json
//
//  Created by Pol Krm on 22.06.22.
//

import UIKit

class ClientCell: UITableViewCell {

    @IBOutlet private weak var clientNameLabel: UILabel!
    
    private var client: Client!
    
    func setup(client: Client) {
        clientNameLabel.text = client.clientName
    }
    func setup(partner: Partner) {
        clientNameLabel.text = partner.name
    }
    
}
