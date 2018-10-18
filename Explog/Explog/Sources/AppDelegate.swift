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
    
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        return true 
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
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
        let mainFeedVC = FeedContainerViewController.create()
        let searchVC = SearchViewController.create()
        let postVC = PostViewController.create()
        let likeVC = LikeViewController.create()
        let profileVC = ProfileViewController.create()
        return MainFeedTabBarViewController(viewControllers: [mainFeedVC, searchVC, postVC, likeVC, profileVC])
        
    }
}
