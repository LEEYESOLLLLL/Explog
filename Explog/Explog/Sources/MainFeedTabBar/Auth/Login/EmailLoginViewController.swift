//
//  LoginViewController.swift
//  Explog
//
//  Created by minjuniMac on 18/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Moya

final class EmailLoginViewController: BaseViewController {
    lazy var v = EmailLoginView(controlBy: self)
    var state: State = .invalidate(textField: nil) {
        didSet {
            switch state {
            case .invalidate(let skyTextField):
                if let skyTextField = skyTextField {
                    v.verifyTextFieldState(skyTextField)
                    v.verifyLoginButtonState()
                }
            case .validate(let skyTextField):
                v.verifyTextFieldState(skyTextField)
                skyTextField.titleColor = .appStyle
                skyTextField.errorMessage = ""
                v.verifyLoginButtonState()
            }
        }
    }
    
    let provider = MoyaProvider<Auth>(plugins: [ NetworkLoggerPlugin() ])
    
    override func loadView() {
        super.loadView()
        view = v
    }
    
    @objc func dismissButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func textFieldDidChange(_ textfield: Any) {
        guard let skyTextField = textfield as? SkyFloatingLabelTextField,
            let identifier = skyTextField.placeholder,
            let text = skyTextField.text,
            let textFieldType = TextFieldType(rawValue: identifier) else {
                return
        }
        
        state = Validate.main.target(text: text, textFieldType: textFieldType) ? .validate(TextField: skyTextField) : .invalidate(textField: skyTextField)
    }
    
    @objc func loginButtonAction(_ sender: ActivityIndicatorButton) {
        sender.startAnimating()
        guard let email = v.emailTextField.text,
            let password = v.passwordTextField.text else {
                sender.stopAnimating()
                return
        }
        provider.request(.login(email: email, password: password)) { [weak self] result in
                guard let strongSelf = self else { return }
                switch result {
                case .success(let response):
                    if 200...299 ~= response.statusCode {
                        do {
                            let loginModel = try response.map(AuthModel.self)
                            KeychainService.configure(material: loginModel.token, key: .token)
                            KeychainService.configure(material: String(loginModel.pk), key: .pk)
                            strongSelf.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                        }catch {
                            print("invalidate LoginModel")
                            sender.stopAnimating()
                        }
                    }else {
                        UIAlertController.showWithAlertAction(
                            alertVCtitle: "유효하지 않은 아이디와 비밀번호 입니다",
                            alertVCmessage: "",
                            alertVCstyle: .alert,
                            isCancelAction: false,
                            actionTitle: "OK",
                            actionStyle: .cancel,
                            action: nil)
                        sender.stopAnimating()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    sender.stopAnimating()
                }
        }
    }
    
    @objc func signUpButtonAction(_ sender: UIButton) {
        let signUpViewController = SignUpViewController()
        signUpViewController.modalPresentationStyle = .overCurrentContext
        show(signUpViewController, sender: nil)
    }
}

extension EmailLoginViewController {
    enum State {
        case validate(TextField: SkyFloatingLabelTextField)
        case invalidate(textField: SkyFloatingLabelTextField?)
    }
}

extension EmailLoginViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let skyTextField = textField as? SkyFloatingLabelTextField,
        let identifier = skyTextField.placeholder,
        let textFieldType = TextFieldType(rawValue: identifier) else {
            return false
        }
        
        switch textFieldType {
        case .email:
            v.passwordTextField.becomeFirstResponder()
            return true
        case .password:
            if v.loginButton.isUserInteractionEnabled {
                loginButtonAction(v.loginButton)
            }
            return true
        case .username:
            return true
        }
    }
}




