//
//  AppDelegate.swift
//  twitter
//
//  Created by christopher ketant on 10/25/16.
//  Copyright © 2016 christopherketant. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        TwitterClient.sharedInstance.fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
            let defaults = UserDefaults.standard
            defaults.set(accessToken?.token, forKey: "kAccessToken")
            defaults.set(accessToken?.secret, forKey: "kSecret")
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let hamburgerViewController = storyboard.instantiateViewController(
                withIdentifier: "hamburgerViewController"
                ) as! HamburgerViewController
            let menuViewController = storyboard.instantiateViewController(
                withIdentifier: "menuViewController"
                ) as! MenuViewController
            User.getCurrentUser(completion: { (currentUser: User?, error: Error?) in
                DispatchQueue.main.async {
                    menuViewController.hamburgerViewController = hamburgerViewController
                    hamburgerViewController.menuViewController = menuViewController
                    self.window?.rootViewController = hamburgerViewController
                }
            })
            
            }, failure: { (error: Error?) in
                print(error?.localizedDescription as Any)
        })
        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UINavigationBar.appearance().barTintColor = UIColor(red: (0/255.0), green: (172/255.0), blue: (237/255.0), alpha: 1.0)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:
            UIColor.white]
        UIBarButtonItem.appearance().tintColor = UIColor.white
        
        let defaults = UserDefaults.standard
        if  defaults.object(forKey: "kAccessToken") != nil && defaults.object(forKey: "kSecret") != nil{
            let secret: String = defaults.object(forKey: "kSecret") as! String
            let token: String = defaults.object(forKey: "kAccessToken") as! String
            let accessToken = BDBOAuth1Credential(token: token, secret: secret, expiration: nil)
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            if TwitterClient.sharedInstance.isAuthorized {
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let hamburgerViewController = storyboard.instantiateViewController(
                    withIdentifier: "hamburgerViewController"
                ) as! HamburgerViewController
                let menuViewController = storyboard.instantiateViewController(
                    withIdentifier: "menuViewController"
                ) as! MenuViewController
                User.getCurrentUser(completion: { (currentUser: User?, error: Error?) in
                    DispatchQueue.main.async {
                        menuViewController.hamburgerViewController = hamburgerViewController
                        hamburgerViewController.menuViewController = menuViewController
                        self.window?.rootViewController = hamburgerViewController
                    }
                    
                })
                }
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

