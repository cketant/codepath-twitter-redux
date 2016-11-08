//
//  ComposeTweetViewController.swift
//  twitter
//
//  Created by christopher ketant on 10/29/16.
//  Copyright © 2016 christopherketant. All rights reserved.
//

import UIKit

protocol NewComposedTweetDelegate: class {
    func updateCache(tweet: Tweet)
}

class ComposeTweetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetCharCountBarButton: UIBarButtonItem!
    @IBOutlet weak var sendTweetBarButton: UIBarButtonItem!
    weak var newComponsedTweetDelegate: NewComposedTweetDelegate?
    var placeholderLabel: UILabel!
    var status: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    // MARK: - Actions
    
    @IBAction func cancel(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tweet(){
        self.view.endEditing(true)
        Tweet.sendTweet(status: self.status!) { (response: NSDictionary?, error: Error?) in
            if let response = response{
                DispatchQueue.main.async {
                    self.newComponsedTweetDelegate?.updateCache(tweet: Tweet(dictionary: response))
                }
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    // MARK: - UITableViewDelegate + UITableViewDatasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 236
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "composeTweetCell", for: indexPath) as! ComposeTableViewCell
        self.placeholderLabel = cell.placeholderLabel
        return cell
    }
    
    // MARK: - UITextView Delegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.placeholderLabel.isHidden = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.placeholderLabel.isHidden = false
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            self.placeholderLabel.isHidden = false
        }
        let statusLength = (140 - textView.text.characters.count)
        if statusLength < 0 {
            self.tweetCharCountBarButton.tintColor = UIColor.red
            self.sendTweetBarButton.isEnabled = false
        }else{
            self.tweetCharCountBarButton.tintColor = UIColor.darkGray
            self.sendTweetBarButton.isEnabled = true
        }
        self.tweetCharCountBarButton.title = "\(statusLength)"
        self.status = textView.text
    }
    
    // MARK: - Utils
    fileprivate func setup(){
        self.profileImageView.setImageWith(User.currentUser.profileUrl!)
        self.profileImageView.layer.cornerRadius = 5
        self.profileImageView.clipsToBounds = true
        self.nameLabel.text = User.currentUser.name
        self.screenNameLabel.text = User.currentUser.screenname
        self.tweetCharCountBarButton.tintColor = UIColor.darkGray
    }
}
