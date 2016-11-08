//
//  MentionsViewController.swift
//  twitter
//
//  Created by christopher ketant on 11/7/16.
//  Copyright © 2016 christopherketant. All rights reserved.
//

import UIKit

class MentionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingActivity: UIActivityIndicatorView!
    private var tweets: [Tweet] = []
    private var tappedUser: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        User.getMentionsTimeline { (tweets: [Tweet]?, error: Error?) in
            if let tweets = tweets{
                self.tweets = tweets
            }
            DispatchQueue.main.async {
                self.tableView.isHidden = false
                self.loadingActivity.stopAnimating()
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Actions
    
    @objc fileprivate func userProfileTapped(_ sender: UITapGestureRecognizer) {
        self.tappedUser = self.tweets[(sender.view?.tag)!].author
        self.performSegue(withIdentifier: "userProfileSegue", sender: nil)
    }

    // MARK: - TableView Delegate + Datasource
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetTableViewCell
        let tweet = self.tweets[indexPath.row]
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
            cell.profileImageView.tag = indexPath.row
            let tapGestureRecognizer = UITapGestureRecognizer(
                target: self, action: #selector(userProfileTapped)
            )
            cell.profileImageView.addGestureRecognizer(tapGestureRecognizer)
            if let url = user.profileUrl{
                cell.profileImageView.setImageWith(url)
                cell.profileImageView.layer.cornerRadius = 5
                cell.profileImageView.clipsToBounds = true
            }
        }
        return cell
    }
    
    fileprivate func setup(){
        // tableview
        self.tableView.estimatedRowHeight = 83
        self.tableView.rowHeight = UITableViewAutomaticDimension
        // initial loading
        self.loadingActivity.hidesWhenStopped = true
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "userProfileSegue"{
            let vc = segue.destination as! ProfileViewController
            vc.user = self.tappedUser
        }
    }
    

}
