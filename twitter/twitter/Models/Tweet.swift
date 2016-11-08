//
//  Tweet.swift
//  twitter
//
//  Created by christopher ketant on 10/27/16.
//  Copyright © 2016 christopherketant. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var stringId: String?
    var text: String?
    var timestamp: Date?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var author: User?
    var isRetweeted: Bool?
    var isFavorited: Bool?
    
    init(dictionary: NSDictionary) {
        self.stringId = dictionary["id_str"] as? String
        self.text = dictionary["text"] as? String
        self.retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        self.favoritesCount = (dictionary["favourites_count"] as? Int) ?? 0
        self.isFavorited = (dictionary["favorited"] as? Bool) ?? false
        self.isRetweeted = (dictionary["retweeted"] as? Bool) ?? false
        if let createdTimeStampStr = dictionary["created_at"] as? String{
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
            self.timestamp = formatter.date(from: createdTimeStampStr)
        }
        if let userDict = dictionary["user"]{
            self.author = User(dictionary: userDict as! NSDictionary)
        }
    }
    
    public func retweet(isRetweeted: Bool){
        let tweetId = self.stringId!
        if isRetweeted {
            TwitterClient.sharedInstance.post("1.1/statuses/retweet/\(tweetId).json", parameters: nil, success: {(task: URLSessionDataTask, response: Any) in
            }){(task: URLSessionDataTask?, error: Error?) in
                if error == nil{
                    self.isRetweeted = true
                }
            }
        }else{
            TwitterClient.sharedInstance.post("1.1/statuses/unretweet/\(tweetId).json", parameters: nil, success: {(task: URLSessionDataTask, response: Any) in
            }){(task: URLSessionDataTask?, error: Error?) in
                if error == nil{
                    self.isRetweeted = false
                }
            }
        }
    }
    
    public func favorite(isFavorited: Bool){
        let tweetId: Int = Int(self.stringId!)!
        let parameters: [String : AnyObject] = ["id": tweetId as AnyObject]
        if isFavorited {
            TwitterClient.sharedInstance.post("1.1/favorites/create.json", parameters: parameters, success: {(task: URLSessionDataTask, response: Any) in
            }){(task: URLSessionDataTask?, error: Error?) in
                if error == nil{
                    self.isFavorited = true
                }
            }
        }else{
            TwitterClient.sharedInstance.post("1.1/favorites/destroy.json", parameters: parameters, success: {(task: URLSessionDataTask, response: Any) in
            }){(task: URLSessionDataTask?, error: Error?) in
                if error == nil{
                    self.isFavorited = false
                }
            }
        }
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet]{
        var tweets: [Tweet] = []
        for dict in dictionaries{
            let tweet = Tweet(dictionary: dict)
            tweets.append(tweet)
        }
        return tweets
    }
    
    class func sendTweet(status: String, completion: @escaping(NSDictionary?, Error?) -> Void) -> Void{
        let parameters: [String : String] = ["status": "\(status)"]
        TwitterClient.sharedInstance.post("1.1/statuses/update.json", parameters: parameters, success: { (task: URLSessionDataTask, response: Any) in
            completion((response as! NSDictionary), nil)
        }) { (task: URLSessionDataTask?, error: Error?) in
            completion(nil, error)
        }
    
    }
}
