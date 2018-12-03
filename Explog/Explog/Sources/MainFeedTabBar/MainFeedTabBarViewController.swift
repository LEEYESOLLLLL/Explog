//
//  MainFeedTabBarViewController.swift
//  Explog
//
//  Created by minjuniMac on 8/21/18.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import Square
import Localize_Swift

final class MainFeedTabBarViewController: BaseTabBarController {
    override init(viewControllers vcs: [UIViewController]) {
        super.init(viewControllers: vcs)
        viewControllers = vcs
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        delegate = self
        UITabBar.appearance().tintColor = .appStyle
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateBadgeNumber()
    }
    
    func updateBadgeNumber() {
        guard let viewControllers = viewControllers else {
            return
        }
        if UIApplication.shared.applicationIconBadgeNumber > 0 {
            viewControllers.forEach {
                guard let title = $0.title,
                    let type = Titles(rawValue: title) else {
                        return
                }
                if type == .Noti {
                    $0.tabBarItem.badgeValue = "\(UIApplication.shared.applicationIconBadgeNumber)"
                }
            }
        }
    }
}

extension MainFeedTabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let vcTitle = viewController.title,
            let title = Titles(localizedString: vcTitle) else {
                return false
        }
        
        guard KeychainService.token != nil else {
            Square.display(
                "Require Login".localized(),
                message: "Do you want to go to the login screen?".localized(),
                alertActions: [
                    .cancel(message: "Cancel".localized()),
                    .default(message: "OK".localized())
            ]) { [weak self] (alertAction, index) in
                guard let self = self else {
                    return
                }
                if index == 1 {
                    let authController = AuthViewController()
                    self.present(authController, animated: true, completion: nil)
                }
            }
            return false
        }
        switch title {
        case .Feed:
            return true
        case .Search:
            return true
        case .Post:
            
            present(PostViewController.create(), animated: true, completion: nil)
            return false
        case .Noti:
            return true
        case .Profile:
            return true
        }
    }
}
