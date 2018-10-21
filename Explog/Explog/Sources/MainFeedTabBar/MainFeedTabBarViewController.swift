//
//  MainFeedTabBarViewController.swift
//  Explog
//
//  Created by minjuniMac on 8/21/18.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

final class MainFeedTabBarViewController: BaseTabBarController {
    
    override func viewDidLoad() {
        delegate = self
        UITabBar.appearance().tintColor = .appStyle
    }
    
}

extension MainFeedTabBarViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        guard let vcTitle = viewController.title,
            let title = Titles(rawValue: vcTitle) else {
            return false
        }
        
        guard KeychainService.token != nil else {
            UIAlertController.showWithAlertAction(
                actionTitle: "Ok",
                actionStyle: .default) { [weak self] _ in
                    guard let strongSelf = self else { return }
                    let authController = AuthViewController()
                    strongSelf.present(authController, animated: true, completion: nil)
            }
            return false
        }
        
        print(viewController.title)
        switch title {
        case .Feed: return true
        case .Search:
            
            return true
        case .Post:
            //self.present(viewController, animated: true, completion: nil)
            let vc = PostViewController()
            present(vc, animated: true, completion: nil)
            return false
        case .Like: return true
        case .Profile: return true
        default: return true 
        }
    }
    
    
    
    
    
}

extension MainFeedTabBarViewController {
    enum Titles: String {
        case Feed
        case Search
        case Post
        case Like
        case Profile
    }
}
