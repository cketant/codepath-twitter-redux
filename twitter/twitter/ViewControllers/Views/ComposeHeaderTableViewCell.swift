//
//  ComposeHeaderTableViewCell.swift
//  twitter
//
//  Created by christopher ketant on 10/31/16.
//  Copyright © 2016 christopherketant. All rights reserved.
//

import UIKit

class ComposeHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
