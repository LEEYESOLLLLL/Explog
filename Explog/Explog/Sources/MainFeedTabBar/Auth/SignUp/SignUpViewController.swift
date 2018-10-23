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

final class SignUpViewController: BaseViewController {
    lazy var v = SignUpView(controlBy: self)
    
    var state: State = .invalidate(textField: nil) {
        didSet {
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
    let provider = MoyaProvider<Auth>(plugins: [ NetworkLoggerPlugin() ])
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func loadView() {
        super.loadView()
        view = v
    }
    
    @objc func dismissButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
    
    @objc func signUpButtonAction(_ sender: ActivityIndicatorButton) {
        // request SiginUp..
        sender.startAnimating()
        guard let username = v.usernameTextField.text,
            let email = v.emailTextField.text,
            let password = v.passwordTextField.text else {
                sender.stopAnimating()
                return
        }
        provider.request(.signUp(
            username: username,
            email: email,
            password: password)) { [weak self] result in
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
                            alertVCtitle: "이메일, 유저네임이 이미 존재합니다.",
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
}

extension SignUpViewController {
    enum State {
        case validate(TextField: SkyFloatingLabelTextField)
        case invalidate(textField: SkyFloatingLabelTextField?)
    }
}

