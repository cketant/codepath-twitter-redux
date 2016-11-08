//
//  TwitterClient.swift
//  twitter
//
//  Created by christopher ketant on 10/26/16.
//  Copyright © 2016 christopherketant. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com")!, consumerKey: "8sZlg9JrKq7YCnP7erHc6TjyU", consumerSecret: "hiCtOgGZIavRpBWXyPVwXiTKGa6FMDoCgYuQrV1mqhDVFPLUDj")!
}
