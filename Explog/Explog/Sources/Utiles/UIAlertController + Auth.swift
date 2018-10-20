//
//  UIAlertController + Auth.swift
//  Explog
//
//  Created by minjuniMac on 18/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

extension UIAlertController {
    /// SwifterSwift: Add an action to Alert
    ///
    /// - Parameters:
    ///   - title: action title
    ///   - style: action style (default is UIAlertActionStyle.default)
    ///   - isEnabled: isEnabled status for action (default is true)
    ///   - handler: optional action handler to be called when button is tapped (default is nil)
    /// - Returns: action created by this method
    //    @discardableResult public func addAction(title: String, style: UIAlertAction.Style = .default, isEnabled: Bool = true, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
    //        let action = UIAlertAction(title: title, style: style, handler: handler)
    //        action.isEnabled = isEnabled
    //        addAction(action)
    //        return action
    //    }
    @discardableResult
    public func show(animated: Bool = true, completion: (() -> Void)? = nil) {
        UIApplication.shared.keyWindow?.rootViewController?.present(self, animated: animated, completion: completion)
    }
    
    func addActions(_ actions: [UIAlertAction]) {
        for action in actions {
            addAction(action)
        }
    }
    
    static func showAuthController(
        to viewController: UIViewController,
        title: String = "로그인이 필요합니다.",
        message: String = "로그인 화면으로 이동 하시겠습니까?",
        style: UIAlertController.Style = .alert)  {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: style)
        
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil)
        let showAuthAction = UIAlertAction(
            title: "Ok",
            style: .default) { _ in
                let authController = AuthViewController()
                let navigationController = UINavigationController(rootViewController: authController)
                navigationController.setNavigationBarHidden(true, animated: false)
                viewController.present(navigationController, animated: true, completion: nil)
        }
        
        alertController.addActions([cancelAction, showAuthAction])
        alertController.show()
        
    }
}

extension UIAlertController {
    
    
    
    // SwifterSwift: Create new alert view controller with default OK action.
    ///
    /// - Parameters:
    ///   - title: alert controller's title.
    ///   - message: alert controller's message (default is nil).
    ///   - defaultActionButtonTitle: default action button title (default is "OK")
    ///   - tintColor: alert controller's tint color (default is nil)
    public convenience init(
        title: String,
        message: String? = nil, defaultActionButtonTitle: String = "OK", tintColor: UIColor? = nil) {
        self.init(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let toAuth = UIAlertAction(title: "Ok", style: .default) { _ in
            print("toAuth")
            
        }
        addAction(defaultAction)
        addAction(toAuth)
        if let color = tintColor {
            view.tintColor = color
        }
    }
    
    
    
    
}
