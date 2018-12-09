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
import SwiftyBeaver
import GDPerformanceView_Swift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
}
// MARK: Setup Keywindow
extension AppDelegate {
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        setKeyWindow()
        return true
    }
    
    private func setKeyWindow() {
        #if DEBUG
        PerformanceMonitor.shared().start()
        PerformanceMonitor.shared().performanceViewConfigurator.options = [.all]
        PerformanceMonitor.shared().show()
        #endif
        
        window = UIWindow(frame: UIScreen.mainbounds)
        if let keyWindow = window {
            keyWindow.restorationIdentifier = "MainWindow"
            keyWindow.rootViewController = AppDelegate.setTabBarViewControllers()
            keyWindow.makeKeyAndVisible()
        }
    }
    
    /// used both in AppDelegate and Change Language in Setting
    static func setTabBarViewControllers() -> UITabBarController {
        // initilize ViewControllers
        let mainFeedVC = BaseNavigiationController(rootViewController: FeedContainerViewController.create())
        let searchVC   = BaseNavigiationController(rootViewController: SearchViewController.create())
        let postVC     = PostViewController.create()
        let likeVC     = NotiViewController.create()
        let profileVC  = BaseNavigiationController(rootViewController: ProfileViewController.create(editMode: .on))
        return MainFeedTabBarViewController(viewControllers: [mainFeedVC, searchVC, postVC, likeVC, profileVC])
    }
}


// MARK: Initialization
extension AppDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        setupLogginService()
        FirebaseApp.configure()
        requesetNotification()
        return true
    }
}

// MARK: Loggin Service
extension AppDelegate  {
    func setupLogginService() {
        let console = ConsoleDestination()
        let platform = SBPlatformDestination(
            appID: "e1PYdR",
            appSecret: "ndeEkqiLos6CWBi4utcqwtzhoaiunf6y",
            encryptionKey: "gtkxf6dbqlrfpxqkulwxt1bgringeLsy")
        SwiftyBeaver.addDestinations([console, platform])
        SwiftyBeaver.verbose("The most recent Time that did finish launching: " + Date().convertedNow())
    }
}


// MARK: Setup Push Notification
extension AppDelegate {
    private func requesetNotification() {
        UNUserNotificationCenter
            .current()
            .requestAuthorization(
            options: [.alert, .sound, .badge]) { (grant, error) in
                SwiftyBeaver.info("grant is \(grant), error is \(String(describing: error?.localizedDescription)))")
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
        SwiftyBeaver.info("Not Getting Token: \(error.localizedDescription)")
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
extension AppDelegate: UNUserNotificationCenterDelegate { }

// MARK: Available to do Preservation & Restoration feature
extension AppDelegate {
    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        #if DEBUG
        let libraryDir = FileManager.default.urls(
            for: .libraryDirectory,
            in: .userDomainMask).first?.appendingPathComponent("Saved Application State")
        SwiftyBeaver.verbose("Restoration files: \(String(describing: libraryDir?.path))")
        #endif
        return true
    }
    
    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }
}
