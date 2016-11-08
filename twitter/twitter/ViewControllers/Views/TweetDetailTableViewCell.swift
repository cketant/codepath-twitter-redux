//
//  TweetDetailTableViewCell.swift
//  twitter
//
//  Created by christopher ketant on 10/29/16.
//  Copyright © 2016 christopherketant. All rights reserved.
//

import UIKit

class TweetDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var contentTextLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var retweetsLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var directMessageButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    public func updateFavoriteButton(isFavorited: Bool){
        if isFavorited {
            self.favoriteButton.setImage(#imageLiteral(resourceName: "star_filled_yellow"), for: .normal)
        }else{
            self.favoriteButton.setImage(#imageLiteral(resourceName: "star_filled"), for: .normal)
        }
    }
    
    public func updateRetweetButton(isRetweeted: Bool){
        if isRetweeted {
            self.retweetButton.setImage(#imageLiteral(resourceName: "retweet_filled_red"), for: .normal)
        }else{
            self.retweetButton.setImage(#imageLiteral(resourceName: "retweet_filled"), for: .normal)
        }
    }
    
    public func updateReplyButton(isReplied: Bool){
        if isReplied{
            self.replyButton.setImage(#imageLiteral(resourceName: "left_filled_red"), for: .normal)
        }else{
            self.replyButton.setImage(#imageLiteral(resourceName: "left_filled"), for: .normal)
        }
    }


}
