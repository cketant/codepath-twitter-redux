//
//  TimelineViewController.swift
//  twitter
//
//  Created by christopher ketant on 10/27/16.
//  Copyright © 2016 christopherketant. All rights reserved.
//

import UIKit
import MBProgressHUD

class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, NewComposedTweetDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingActivity: UIActivityIndicatorView!
    private var loadingMoreView: InfiniteScrollActivityView!
    let refreshControl: UIRefreshControl! = UIRefreshControl()
    private var tweets: [Tweet] = []
    private var selectedTweet: Tweet!
    private var isTweetsLoading: Bool = false
    private var tappedUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.loadingActivity.startAnimating()
        User.getHomeTimeline { (tweets: [Tweet]?, error: Error?) in
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
    
    @IBAction func signout(){
        let alert = UIAlertController(title: "", message: "Are you sure you want to signout?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .destructive) { (action: UIAlertAction) in
            TwitterClient.sharedInstance.deauthorize()
            let defaults = UserDefaults.standard
            defaults.removeObject(forKey: "kAccessToken")
            defaults.removeObject(forKey: "kSecret")
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let nav = storyboard.instantiateViewController(withIdentifier: "LoginNavigationController") as! UINavigationController
            DispatchQueue.main.async {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = nav
            }

        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action: UIAlertAction) in
            
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - UITableView delegate+datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        self.selectedTweet = self.tweets[indexPath.row]
        self.performSegue(withIdentifier: "detailTweetSegue", sender: nil)
    }
    
    // MARK: - ScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !self.isTweetsLoading {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = self.tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                self.isTweetsLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: self.tableView.contentSize.height, width: self.tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                self.loadingMoreView.frame = frame
                self.loadingMoreView.startAnimating()
                self.loadNewTweets()
            }
            
        }
    }
    
    // MARK: - NewComposedTweetDelegate
    
    func updateCache(tweet: Tweet){
        self.tweets.insert(tweet, at: 0)
        self.tableView.reloadData()
    }
    
    // MARK: - Utils
    
    @objc fileprivate func loadNewTweets(){
        let latestTweet = self.tweets.first
        User.getHomeTimeline(count: 20, sinceId: (latestTweet?.stringId)!) { (tweets: [Tweet]?, error: Error?) in
            if let tweets = tweets{
                self.tweets = tweets + self.tweets
                if tweets.count > 0{
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
            if self.refreshControl.isRefreshing{
                self.refreshControl.endRefreshing()
            }
            if self.isTweetsLoading{
                self.isTweetsLoading = false
                self.loadingMoreView.stopAnimating()
            }

        }
    }
    
    fileprivate func setup(){
        // tableview
        self.tableView.estimatedRowHeight = 83
        self.tableView.rowHeight = UITableViewAutomaticDimension
        // loading more view
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        self.tableView.addSubview(loadingMoreView!)
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        self.tableView.contentInset = insets
        // pull to refresh
        self.refreshControl.addTarget(self, action: #selector(loadNewTweets), for: UIControlEvents.valueChanged)
        self.tableView.insertSubview(self.refreshControl, at: 0)
        // initial loading
        self.loadingActivity.hidesWhenStopped = true
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "detailTweetSegue" {
            let vc = segue.destination as! TweetDetailViewController
            vc.tweet = self.selectedTweet
        }else if segue.identifier == "userProfileSegue"{
            let vc = segue.destination as! ProfileViewController
            vc.user = self.tappedUser
        }else{
            let nav = segue.destination as! UINavigationController
            let vc = nav.viewControllers.first as! ComposeTweetViewController
            vc.newComponsedTweetDelegate = self
        }
        
    }
 

}
