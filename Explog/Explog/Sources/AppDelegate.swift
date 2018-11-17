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
import Firebase


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
}

// MARK: Initialization
extension AppDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // MARK: temporarily
        FirebaseApp.configure()
        setKeyWindow()
        requesetNotification()
        return true
    }
    
    private func setKeyWindow() {
        window = UIWindow(frame: UIScreen.mainbounds)
        window?.rootViewController = setTabBarViewControllers()
        window?.makeKeyAndVisible()
    }
    
    private func setTabBarViewControllers() -> UITabBarController {
        // initilize ViewControllers
        let mainFeedVC = FeedContainerViewController.create()
        let searchVC   = UINavigationController(rootViewController: SearchViewController.create())
        let postVC     = PostViewController.create()
        let likeVC     = NotiViewController.create()
        let profileVC  = UINavigationController(rootViewController: ProfileViewController.create(editMode: .on))
        return MainFeedTabBarViewController(viewControllers: [mainFeedVC, searchVC, postVC, likeVC, profileVC])
    }
    
    private func requesetNotification() {
        UNUserNotificationCenter
            .current()
            .requestAuthorization(
            options: [.alert, .sound, .badge]) { (grant, error) in
                print("grant is \(grant), error is \(String(describing: error?.localizedDescription)))")
                if grant == true {
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                        UNUserNotificationCenter.current().delegate = self
                    }
                }
        }
    }
}

// MARK: initial Setting for noti 
extension AppDelegate {
    // this method is called if user permit app getting Notification,
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceToken = deviceToken
            .map { return String(format: "%02.2hhx", $0) }
            .joined()
        KeychainService.configure(material: deviceToken, key: .deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Not Getting Token: \(error.localizedDescription)")
    }
}

extension AppDelegate {
    // When being touched through noti
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        //        guard let apsInfo = userInfo["aps"] as? [String: Any], let numberOfBadge = apsInfo["badge"] as? Int else {
        //            return
        //        }
        setupBadge(application)
    }
    
    public func applicationDidBecomeActive(_ application: UIApplication) {
        setupBadge(application)
        
    }
    
    func setupBadge(_ application: UIApplication) {
        guard let rootVC = application.keyWindow?.rootViewController as? MainFeedTabBarViewController,
            let viewControllers = rootVC.viewControllers else {
                return
        }
        viewControllers.forEach {
            guard let title = $0.title,
                let type = MainFeedTabBarViewController.Titles(rawValue: title) else {
                    return
            }
            if type == MainFeedTabBarViewController.Titles.Noti {
                $0.tabBarItem.badgeValue = UIApplication.shared.applicationIconBadgeNumber == 0 ? nil : "\(UIApplication.shared.applicationIconBadgeNumber)"
            }
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
}
