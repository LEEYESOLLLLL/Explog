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
        let mainFeedVC = UINavigationController(
            rootViewController: MainFeedViewController.createWith())
        let searchVC = SearchViewController.createWith()
        let postVC = PostViewController.createWith()
        let likeVC = LikeViewController.createWith()
        let profileVC = ProfileViewController.createWith()
        return MainFeedTabBarViewController(viewControllers: [mainFeedVC, searchVC, postVC, likeVC, profileVC])
        
    }
}
