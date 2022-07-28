//
//  ProfileCell.swift
//  PalitraProduct2
//
//  Created by Павел on 27.07.2022.
//

import UIKit

class ProfileCell: UITableViewCell {

    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var icon: UIImageView!
    
    func setTitle(title: String, image: UIImage) {
        self.title.text = title
        icon.image = image
    }
}
