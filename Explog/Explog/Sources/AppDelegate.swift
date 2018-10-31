//
//  AppDelegate.swift
//  Explog
//
//  Created by minjuniMac on 8/21/18.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import KeychainAccess
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true 
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // MARK: temporarily
        setKeyWindow()
        requesetNotification()
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
        let profileVC = UINavigationController(rootViewController: ProfileViewController.create(editMode: .on))
        return MainFeedTabBarViewController(viewControllers: [mainFeedVC, searchVC, postVC, likeVC, profileVC])
    }
    
    private func requesetNotification() {
        UNUserNotificationCenter
            .current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { (grant, error) in                 print("grant is \(grant), error is \(String(describing: error?.localizedDescription)))")
                if grant == true {
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                        UNUserNotificationCenter.current().delegate = self
                    }
                }
        }
    }
    
    // this method is called if user permit app getting Notification,
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceToken = deviceToken
            .map { (data) -> String in
                return String(format: "%02.2hhx", data)
        }.joined()
        
        
        KeychainService.configure(material: deviceToken, key: .deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Not Getting Token: \(error.localizedDescription)")
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
}
