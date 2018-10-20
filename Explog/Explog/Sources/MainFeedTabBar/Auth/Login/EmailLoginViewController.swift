//
//  LoginViewController.swift
//  Explog
//
//  Created by minjuniMac on 18/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

final class EmailLoginViewController: BaseViewController {
    
    lazy var v = EmailLoginView(controlBy: self)
    var state: State = .invalidate(textField: nil) {
        didSet {
            switch state {
            case .invalidate(let skyTextField):
                skyTextField?.titleColor = .gray
                skyTextField?.errorMessage = "Invaild Email"
                v.verifyLoginButtonState()
            case .validate(let skyTextField):
                skyTextField.titleColor = .appStyle
                skyTextField.errorMessage = ""
                v.verifyLoginButtonState()
            }
        }
    }
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
    
    @objc func loginButtonAction(_ sender: UIButton) {
        // Login API 추상화해야함..
        // API Request 후 성공, 실패에 따라서 분기 처리
        // 성공하면 모든 회원가입 화면 내리고 ->
        // 실패하면 실패한것에 대한 AlertMessage 띄워주기..
        
    }
}

extension EmailLoginViewController {
    enum State {
        case validate(TextField: SkyFloatingLabelTextField)
        case invalidate(textField: SkyFloatingLabelTextField?)
    }
}




