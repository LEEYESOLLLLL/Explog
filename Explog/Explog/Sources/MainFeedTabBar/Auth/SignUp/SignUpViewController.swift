//
//  SignUpViewController.swift
//  Explog
//
//  Created by minjuniMac on 18/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Moya
import Square
import SwiftyBeaver

extension SignUpViewController {
    enum State {
        case validate(TextField: SkyFloatingLabelTextField)
        case invalidate(textField: SkyFloatingLabelTextField?)
    }
}

final class SignUpViewController: BaseViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    required init() {
        super.init()
        restorationClass = type(of: self)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var v = SignUpView(controlBy: self)
    var state: State = .invalidate(textField: nil) {
        didSet {
            managingState()
        }
    }
    let provider = MoyaProvider<Auth>()//(plugins: [ NetworkLoggerPlugin() ])
    override func loadView() {
        super.loadView()
        view = v
    }
    
    private func managingState() {
        switch state {
        case .invalidate(let skyTextField):
            if let skyTextField = skyTextField {
                v.verifyTextFieldState(skyTextField)
            }
            v.verifySignUpButtonState()
        case .validate(let skyTextField):
            v.verifyTextFieldState(skyTextField)
            skyTextField.titleColor = .appStyle
            skyTextField.errorMessage = ""
            v.verifySignUpButtonState()
        }
    }
}

// MARK: Actions
extension SignUpViewController {
    @objc func dismissButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func textFieldDidChange(_ textField: Any) {
        guard let skyTextField = textField as? SkyFloatingLabelTextField,
            let identifier = skyTextField.placeholder,
            let text = skyTextField.text,
            let textFieldType = TextFieldType(rawValue: identifier) else {
                return
        }
        
        state = Validate.main.target(text: text, textFieldType: textFieldType) ? .validate(TextField: skyTextField) : .invalidate(textField: skyTextField)
    }
    
    @objc func showSecurityTextButtonAction(_ sender: UIButton){
        v.showSecurityText()
    }
    
}

// MARK: Registe USER in Serve
extension SignUpViewController {
    // Request SiginUp..
    @objc func signUpButtonAction(_ sender: ActivityIndicatorButton) {
        sender.startAnimating()
        guard let username = v.usernameTextField.text,
            let email = v.emailTextField.text,
            let password = v.passwordTextField.text else {
                sender.stopAnimating()
                return
        }
        provider.request(.signUp(username: username, email: email, password: password)) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    if 200...299 ~= response.statusCode {
                        do {
                            let loginModel = try response.map(AuthModel.self)
                            KeychainService.configure(material: loginModel.token, key: .token)
                            KeychainService.configure(material: String(loginModel.pk), key: .pk)
                            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                        }catch {
                            SwiftyBeaver.debug("invalidate LoginModel")
                        }
                    }else {
                        Square.display("Email and User Name already exists")
                    }
                case .failure(let error): SwiftyBeaver.error(error.localizedDescription)
                }
                sender.stopAnimating()
        }
    }
}

extension SignUpViewController: UIViewControllerRestoration {
    static func viewController(withRestorationIdentifierPath identifierComponents: [String], coder: NSCoder) -> UIViewController? {
        return self.init()
    }
}
