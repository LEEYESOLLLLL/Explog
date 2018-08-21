//
//  AppDelegate.swift
//  Explog
//
//  Created by minjuniMac on 8/21/18.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        return true 
        
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        setKeyWindow()
        return true
    }
    
    func setKeyWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = setTabBarViewControllers()
        
        window?.makeKeyAndVisible()
    }
    
    func setTabBarViewControllers() -> UITabBarController {
        
        // initilize ViewControllers
        let mainFeedVC = UINavigationController(rootViewController: MainFeedViewController())
        mainFeedVC.title = "Feed"
        mainFeedVC.tabBarItem.image = #imageLiteral(resourceName: "mainFeed")
        
        let searchVC = SearchViewController()
        searchVC.title = "Search"
        searchVC.tabBarItem.image = #imageLiteral(resourceName: "search")
        
        let postVC = PostViewController()
        postVC.title = "Post"
        
        postVC.tabBarItem.image = #imageLiteral(resourceName: "create_post")
        let likeVC = LikeViewController()
        likeVC.title = "Like"
        likeVC.tabBarItem.image = #imageLiteral(resourceName: "LikeImageInTab")
        
        let profileVC = ProfileViewController()
        profileVC.title = "Profile"
        profileVC.tabBarItem.image = #imageLiteral(resourceName: "profileImage")
        
        
        return MainFeedTabBarViewController(viewControllers: [mainFeedVC, searchVC, postVC, likeVC, profileVC])
        
    }
}
