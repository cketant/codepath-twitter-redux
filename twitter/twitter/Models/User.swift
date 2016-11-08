//
//  User.swift
//  twitter
//
//  Created by christopher ketant on 10/27/16.
//  Copyright © 2016 christopherketant. All rights reserved.
//

import UIKit

class User: NSObject {
    static var currentUser: User!
    var name: String?
    var userId: String?
    var screenname: String?
    var profileUrl: URL?
    var backgroundUrl: URL?
    var tagline: String?
    var followersCount: Int?
    var followingCount: Int?
    var tweetsCount: Int?
    
    init(dictionary: NSDictionary) {
        self.userId = dictionary["id_str"] as? String
        self.name = dictionary["name"] as? String
        self.screenname = dictionary["screen_name"] as? String
        self.tagline = dictionary["description"] as? String
        self.tweetsCount = dictionary["statuses_count"] as? Int
        self.followersCount = dictionary["followers_count"] as? Int
        self.followingCount = dictionary["friends_count"] as? Int
        let profileImgUrlStr = dictionary["profile_image_url"] as? String
        if let profileImgUrlStr = profileImgUrlStr{
            self.profileUrl = URL(string: profileImgUrlStr)
        }
        let backgroundImgUrlStr = dictionary["profile_background_image_url"] as? String
        if let backgroundImgUrlStr = backgroundImgUrlStr {
            self.backgroundUrl = URL(string: backgroundImgUrlStr)
        }
    }
    
    static func getCurrentUser(completion: @escaping (User?, Error?) -> Void) -> Void {
        TwitterClient.sharedInstance.get("1.1/account/verify_credentials.json", parameters: nil, success: { (task: URLSessionDataTask, response: Any) in
            print("account: \(response)")
            if let response = response as? NSDictionary{
                self.currentUser = User(dictionary: response)
                completion(self.currentUser, nil)
            }
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            completion(nil, error)
        })
    }

    class func getHomeTimeline(count: Int = 20,
                               sinceId: String = "",
                               maxId: String = "",
                               completion: @escaping ([Tweet]?, Error?) -> Void) -> Void {
        var parameters: [String : AnyObject] = [:]
        parameters["count"] = count as AnyObject?
        if !sinceId.isEmpty {
            parameters["since_id"] = sinceId as AnyObject?
        }
        if !maxId.isEmpty {
            parameters["maxId"] = maxId as AnyObject?
        }
        TwitterClient.sharedInstance.get("1.1/statuses/home_timeline.json", parameters: parameters, success: { (task: URLSessionDataTask, response: Any) in
            if let response = response as? [NSDictionary]{
                let sortedTweets = Tweet.tweetsWithArray(dictionaries: response).sorted(by: {$0.timestamp?.compare($1.timestamp!) == .orderedDescending})
                completion(sortedTweets, nil)
            }
        }, failure: {(task: URLSessionDataTask?, error: Error) in
            completion(nil, error)
        })
    }
    
    class func getMentionsTimeline(count: Int = 20,
                                   sinceId: String = "",
                                   maxId: String = "",
                                   completion: @escaping ([Tweet]?, Error?) -> Void) -> Void {
        var parameters: [String : AnyObject] = [:]
        parameters["count"] = count as AnyObject?
        if !sinceId.isEmpty {
            parameters["since_id"] = sinceId as AnyObject?
        }
        if !maxId.isEmpty {
            parameters["maxId"] = maxId as AnyObject?
        }
        TwitterClient.sharedInstance.get("1.1/statuses/mentions_timeline.json", parameters: parameters, success: { (task: URLSessionDataTask, response: Any) in
            if let response = response as? [NSDictionary]{
                let sortedTweets = Tweet.tweetsWithArray(dictionaries: response).sorted(by: {$0.timestamp?.compare($1.timestamp!) == .orderedDescending})
                completion(sortedTweets, nil)
            }
        }, failure: {(task: URLSessionDataTask?, error: Error) in
            completion(nil, error)
        })
    }
    
    func getUserTimeline(count: Int = 20,
                           sinceId: String = "",
                           maxId: String = "",
                           completion: @escaping ([Tweet]?, Error?) -> Void) -> Void {
        var parameters: [String : AnyObject] = [:]
        parameters["count"] = count as AnyObject?
        if !sinceId.isEmpty {
            parameters["since_id"] = sinceId as AnyObject?
        }
        if !maxId.isEmpty {
            parameters["maxId"] = maxId as AnyObject?
        }
        parameters["user_id"] = self.userId as AnyObject?
        TwitterClient.sharedInstance.get("1.1/statuses/user_timeline.json", parameters: parameters, success: { (task: URLSessionDataTask, response: Any) in
            if let response = response as? [NSDictionary]{
                let sortedTweets = Tweet.tweetsWithArray(dictionaries: response).sorted(by: {$0.timestamp?.compare($1.timestamp!) == .orderedDescending})
                completion(sortedTweets, nil)
            }
            }, failure: {(task: URLSessionDataTask?, error: Error) in
                completion(nil, error)
        })
    }

    
}
