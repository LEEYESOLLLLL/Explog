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
         
        
    }
    
}

extension MainFeedTabBarViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        //print(viewController.title)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        print(viewController.title)
        
        switch viewController.title {
        case "Feed": return true
        case "Search": return true
        case "Post":
            //self.present(viewController, animated: true, completion: nil)
            let vc = PostViewController()
            present(vc, animated: true, completion: nil)
            return false
        case "Like": return true
        case "Profile": return true
        default: return true 
        }
    }
    
    
    
    
    
}
