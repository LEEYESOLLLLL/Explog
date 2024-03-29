//
//  SettingProfileViewController.swift
//  Explog
//
//  Created by minjuniMac on 01/11/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Moya
import Square
import SwiftyBeaver

extension SettingProfileViewController {
    enum State {
        case loading
        case ready(model: UserModel)
    }
}
final class SettingProfileViewController: BaseViewController {
    lazy var v = SettingProfileView(controlBy: self)
    override func loadView() {
        super.loadView()
        view = v
    }
    
    static func create() -> Self {
        let `self` = self.init()
        self.restorationClass = type(of: self)
        return self
    }
    
    let provider = MoyaProvider<User>()//(plugins: [NetworkLoggerPlugin()])
    override func viewDidLoad() {
        super.viewDidLoad()
        v.start(true)
        provider.request(.profile(otherUserPK: nil)) { [weak self] (result) in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let response):
                switch (200...299) ~= response.statusCode {
                case true :
                    do {
                        let model = try response.map(UserModel.self)
                        self.v.configureUI(with: model)
                    }catch {
                        SwiftyBeaver.debug("fail to convert Model: \(#function)")
                    }
                case false:
                    SwiftyBeaver.debug("fail to Request: \(#function)")
                }
            case .failure(let error):
                SwiftyBeaver.error(error.localizedDescription)
            }
            UIView.animate(withDuration: 0.3) { self.v.start(false) }
        }
    }
}

// MARK: UIBarButtonItem
extension SettingProfileViewController {
    @objc func backButtonAction(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func doneButtonAction(_ sender: UIBarButtonItem) {
        guard let username = v.userNameTextField.text, username.count > 3,
            let imageView = v.profileImageButton.imageView,
            let photo = imageView.image else {
                return
        }
        provider.request(.updateProfile(username: username, photo: photo)) { [weak self] (result) in
            guard let self = self  else {
                return
            }
            switch result {
            case .success(let response):
                switch (200...299) ~= response.statusCode {
                case true : self.navigationController?.popViewController(animated: true)
                case false: Square.display("Alredy exist input username")
                }
                
            case .failure(let error):
                SwiftyBeaver.error("\(error.localizedDescription)")
            }
        }
    }
}

// MARK: Change Profile Information
extension SettingProfileViewController {
    @objc func profileButtonAction(_ sender: UIButton) {
        let photoVC = SettingProfilePhotoViewController.create()
        photoVC.delegate = self
        navigationController?.pushViewController(photoVC, animated: true)
    }
    
    @objc func textFieldDidChange(_ textfield: SkyFloatingLabelTextField) {
        guard let identifier = textfield.placeholder,
            let textFieldType = TextFieldType(rawValue: identifier),
            let text = textfield.text, text.count > 0 else {
                return
        }
        let isValidate = Validate.main.target(text: text, textFieldType: textFieldType)
        switch isValidate {
        case true: textfield.errorMessage = ""
        case false: textfield.errorMessage = "Invaild Username"
        }
    }
}

extension SettingProfileViewController: PassableDataDelegate {
    func pass(data: UIImage) {
        v.configure(image: data)
    }
}

extension SettingProfileViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        doneButtonAction(v.doneButton)
        return true
    }
}

extension SettingProfileViewController: UIViewControllerRestoration {
    static func viewController(withRestorationIdentifierPath identifierComponents: [String], coder: NSCoder) -> UIViewController? {
        return self.create()
    }
}
