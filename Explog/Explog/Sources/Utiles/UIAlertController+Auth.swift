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
        if let presentedViewController = UIApplication.shared.keyWindow?.rootViewController?.presentedViewController {
            presentedViewController.show(self, sender: nil)
        }else {
            UIApplication.shared.keyWindow?.rootViewController?.present(self, animated: animated, completion: completion)
        }
        
    }
    static func showWithAlertAction(
        alertVCtitle: String = "로그인이 필요합니다.",
        alertVCmessage: String = "로그인 화면으로 이동 하시겠습니까?",
        alertVCstyle: UIAlertController.Style = .alert,
        isCancelAction: Bool = true,
        actionTitle: String,
        actionStyle: UIAlertAction.Style,
        action: ((UIAlertAction) -> Void)?) {
        // 1
        let alertController = UIAlertController(
            title: alertVCtitle,
            message: alertVCmessage,
            preferredStyle: alertVCstyle)
        
        // 2
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil)
        
        // 3
        let action = UIAlertAction(
            title: actionTitle,
            style: actionStyle,
            handler: action)
        
        // 4
        alertController.addActions(isCancelAction ? [cancelAction, action] : [action])
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

extension UIAlertController {
    func addActions(_ actions: [UIAlertAction]) {
        for action in actions {
            addAction(action)
        }
    }
}
