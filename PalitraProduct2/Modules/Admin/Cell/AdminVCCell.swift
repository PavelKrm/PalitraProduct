//
//  AdminVCCell.swift
//  PalitraProduct2
//
//  Created by Pol Krm on 1.08.22.
//

import UIKit

class AdminVCCell: UITableViewCell {

    @IBOutlet private weak var fullNameLabel: UILabel!
    
    func showName(fullName: String) {
        fullNameLabel.text = fullName
    }
}
