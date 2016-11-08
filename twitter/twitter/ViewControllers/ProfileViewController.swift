//
//  ProfileViewController.swift
//  twitter
//
//  Created by christopher ketant on 11/5/16.
//  Copyright © 2016 christopherketant. All rights reserved.
//

import UIKit
import MBProgressHUD

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var user: User!
    var tweets: [Tweet] = []
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    //MARK: - TableView Datasource
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetTableViewCell
            let tweet: Tweet = self.tweets[indexPath.row]
            cell.contentTextLabel.text = tweet.text
            if let createdAtDate = tweet.timestamp  {
                let calender = Calendar.current
                let components = calender.dateComponents(Set<Calendar.Component>([.year, .month, .day, .hour, .minute, .second]), from: createdAtDate, to: Date())
                
                if components.year! > 0{
                    let formatter = DateFormatter()
                    formatter.dateStyle = .short
                    cell.daysAgoLabel.text = "\(formatter.string(from: createdAtDate))"
                }else if(components.month! > 0){
                    cell.daysAgoLabel.text = "\(components.month!)m"
                }else if components.day! > 0{
                    cell.daysAgoLabel.text = "\(components.day!)d"
                }else if(components.hour! > 0){
                    cell.daysAgoLabel.text = "\(components.hour!)h"
                }else if(components.minute! > 0){
                    cell.daysAgoLabel.text = "\(components.minute!)M"
                }else{
                    cell.daysAgoLabel.text = "\(components.second!)s"
                }
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
            return cell
        }
    }
    //MARK: - TableView Delegate
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { // stats
            return 1
        }else{
            return self.tweets.count
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 56
        }
        return 0
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let view = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "StatsSectionView")
            let header = view as! StatsSectionView
            header.numFollowersLabel.text = "\(self.user.followersCount!)"
            header.numFollowingLabel.text = "\(self.user.followingCount!)"
            header.numOfTweetsLabel.text = "\(self.user.tweetsCount!)"
            return header
        }
        return nil
    }
    
    //MARK: - Utils
    
    fileprivate func setup(){
        // tableview
        self.tableView.estimatedRowHeight = 83
        self.tableView.rowHeight = UITableViewAutomaticDimension
        if self.user == nil{
            self.user = User.currentUser
        }
        // navbar
        self.navigationController?.navigationBar.barTintColor = UIColor(red: (0/255.0), green: (172/255.0), blue: (237/255.0), alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:
            UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor(
            red: (0/255.0), green: (172/255.0), blue: (237/255.0), alpha: 1.0
        )
        
        let nib = UINib(nibName: "StatsSectionView", bundle: nil)
        self.tableView.register(nib, forHeaderFooterViewReuseIdentifier: "StatsSectionView")
        self.nameLabel.text = self.user.name
        self.screenNameLabel.text = "@\(self.user.screenname!)"
        self.profileImageView.setImageWith(self.user.profileUrl!)
        self.profileImageView.layer.cornerRadius = 6
        self.profileImageView.clipsToBounds = true
        self.backgroundImageView.setImageWith(self.user.backgroundUrl!)
        MBProgressHUD.showAdded(to: self.view, animated: false)
        self.user.getUserTimeline { (tweets: [Tweet]?, error: Error?) in
            if error == nil {
                self.tweets = tweets!
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            }
        }
    }

}
