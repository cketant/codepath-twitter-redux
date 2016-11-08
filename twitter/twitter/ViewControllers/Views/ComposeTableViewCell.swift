//
//  composeTableViewCell.swift
//  twitter
//
//  Created by christopher ketant on 10/31/16.
//  Copyright © 2016 christopherketant. All rights reserved.
//

import UIKit

class ComposeTableViewCell: UITableViewCell {
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var placeholderLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
