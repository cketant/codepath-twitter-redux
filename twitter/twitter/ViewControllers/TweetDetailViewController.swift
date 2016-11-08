//
//  TweetDetailViewController.swift
//  twitter
//
//  Created by christopher ketant on 10/29/16.
//  Copyright © 2016 christopherketant. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var tweet: Tweet!
    private var tweetCell: TweetDetailTableViewCell!
    private var isCellFavorited: Bool?
    private var isCellRetweeted: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // tableview
        self.tableView.estimatedRowHeight = 172
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0)
        self.isCellFavorited = self.tweet.isFavorited
        self.isCellRetweeted = self.tweet.isRetweeted
    }
    
    // MARK: - Tableview Delegate Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetDetailCell", for: indexPath) as! TweetDetailTableViewCell
        cell.nameLabel.text = self.tweet.author?.name
        cell.screenNameLabel.text = self.tweet.author?.screenname
        cell.contentTextLabel.text = self.tweet.text
        cell.retweetsLabel.text = "\(self.tweet.retweetCount)"
        cell.likesLabel.text = "\(self.tweet.favoritesCount)"
        cell.updateFavoriteButton(isFavorited: self.tweet.isFavorited!)
        cell.updateRetweetButton(isRetweeted: self.tweet.isRetweeted!)
        if let createdAtDate = tweet.timestamp  {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yy, hh:mm a"
            cell.createdAtLabel.text = formatter.string(from: createdAtDate)
        }
        if let user = tweet.author {
            cell.nameLabel.text = user.name
            cell.screenNameLabel.text = "@\(user.screenname!)"
            if let url = user.profileUrl{
                cell.profileImageView.setImageWith(url)
                cell.profileImageView.layer.cornerRadius = 5
                cell.profileImageView.clipsToBounds = true
            }
        }
        self.tweetCell = cell
        return cell
    }
    
    // MARK: - Actions
    
    @IBAction func userProfileTapped(_ sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "userProfileSegue", sender: nil)
    }
    
    @IBAction func favorite(){
        self.isCellFavorited = !(self.isCellFavorited!)
        self.tweetCell.updateFavoriteButton(isFavorited: self.isCellFavorited!)
        self.tweet.favorite(isFavorited: !(self.tweet.isFavorited!))
        var num = Int(self.tweetCell.likesLabel.text!)!
        if self.isCellFavorited! {
            num = num + 1
        }else{
            num = num - 1
        }
        self.tweetCell.likesLabel.text = "\(num)"
    }
    @IBAction func retweet(){
        self.isCellRetweeted = !(self.isCellRetweeted!)
        self.tweetCell.updateRetweetButton(isRetweeted: self.isCellRetweeted!)
        self.tweet.retweet(isRetweeted: !(self.tweet.isRetweeted!))
        var num = Int(self.tweetCell.retweetsLabel.text!)!
        if self.isCellRetweeted! {
            num = num + 1
        }else{
            num = num - 1
        }
        self.tweetCell.retweetsLabel.text = "\(num)"
    }
    @IBAction func reply(){
        
    }
    
    @IBAction func directMessage(){
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ProfileViewController
        vc.user = self.tweet.author
            
    }
    
}
