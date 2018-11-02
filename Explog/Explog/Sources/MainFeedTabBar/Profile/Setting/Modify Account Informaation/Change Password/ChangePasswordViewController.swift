//
//  ChangeViewController.swift
//  Explog
//
//  Created by MinjunJu on 02/11/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Square
import Moya

final class ChangePasswordViewController: BaseViewController  {
    static func create() -> ChangePasswordViewController {
        let `self` = self.init()
        return self
    }
    lazy var v = ChangePasswordView(controlBy: self)
    
    let provider = MoyaProvider<User>(plugins: [NetworkLoggerPlugin()])
    override func loadView() {
        super.loadView()
        view = v
    }
}

extension ChangePasswordViewController  {
    @objc func backButtonAction(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)   
    }
    
    @objc func doneButtonAction(_ sender: UIBarButtonItem) {
        guard let oldPassword = v.oldPasswordTextField.text,
            let newPassword = v.changePasswordTextField.text,
            let confirmPassword = v.confirmPasswordTextField.text,
            newPassword == confirmPassword else {
                Square.display("The new password and confirm password are not the same")
                return
        }
        
        provider.request(.updatePassword(oldPassword: oldPassword,
                                         newPassword: newPassword)) { [weak self] (result) in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .success(let response):
                switch (200...299) ~= response.statusCode {
                case true :
                    Square.display("Your password change was successful.", message: "",
                                   alertAction: ActionType.default(message: "OK"),
                                   acceptBlock: {
                                    strongSelf.navigationController?.popViewController(animated: true)
                    })
                case false : Square.display("The old password is invalid.")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension ChangePasswordViewController {
    @objc func textFieldDidChange(_ textfield: SkyFloatingLabelTextField) {
        textfield.placeholder = "Password" // identify for type
        guard let text = textfield.text,
            let identifier = textfield.placeholder,
            let type = TextFieldType(rawValue: identifier) else {
                return
        }
        
        let isValidate = Validate.main.target(text: text, textFieldType: type)
        
        switch isValidate {
        case true:
            textfield.errorMessage = ""
            guard let oldPasswordTextFieldErrorMessage = v.oldPasswordTextField.errorMessage,
                let changePasswordTestFieldErrorMessage = v.changePasswordTextField.errorMessage,
                let confirmPasswordTextFieldErrorMessage = v.confirmPasswordTextField.errorMessage,
                oldPasswordTextFieldErrorMessage.count == 0,
                changePasswordTestFieldErrorMessage.count == 0,
                confirmPasswordTextFieldErrorMessage.count == 0 else {
                    return
            }
            
            v.isActiveDoneButton(true)
        case false:
            textfield.errorMessage = "Invalidate Password"
            v.isActiveDoneButton(false)
        }
    }
}
