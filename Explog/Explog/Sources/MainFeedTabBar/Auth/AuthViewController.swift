//
//  AuthViewController.swift
//  Explog
//
//  Created by minjuniMac on 18/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

// iPhone XR = height & width -> 22
//  - XR Height 896
// iPhone 6s = 22
// iPhone SE = 22

import UIKit

final class AuthViewController: BaseViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    lazy var v = AuthView(controlBy: self)
    override func loadView() {
        super.loadView()
        view = v
    }
    
    required init() {
        super.init()
        restorationClass = type(of: self)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension AuthViewController {
    @objc func dismissButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func emailButtonAction(_ sender: UIButton) {
        let emailLoginViewController = EmailLoginViewController()
        emailLoginViewController.modalPresentationStyle = .overCurrentContext // for Blureffect
        show(emailLoginViewController, sender: nil)
    }
    
    @objc func signUpButtonAction(_ sender: UIButton) {
        let signUpViewController = SignUpViewController()
        signUpViewController.modalPresentationStyle = .overCurrentContext
        show(signUpViewController, sender: nil)
    }
}
extension AuthViewController: UIViewControllerRestoration {
    static func viewController(withRestorationIdentifierPath identifierComponents: [String], coder: NSCoder) -> UIViewController? {
        return self.init()
    }
}
