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
    
    static func create() -> SettingProfileViewController {
        let `self` = self.init()
        return self
    }
    
    var state: State = .loading {
        didSet {
            switch state {
            case .loading: break
            case .ready(_): break
            }
        }
    }
    
    let provider = MoyaProvider<User>(plugins: [NetworkLoggerPlugin()])
    override func viewDidLoad() {
        super.viewDidLoad()
        v.start(true)
        provider.request(.profile(otherUserPK: nil)) { [weak self] (result) in
            guard let strongSelf = self else {
                return
            }
            
            switch result {
            case .success(let response):
                switch (200...299) ~= response.statusCode {
                case true :
                    do {
                        let model = try response.map(UserModel.self)
                        strongSelf.v.configureUI(with: model)
                    }catch {
                        print("fail to convert Model: \(#function)")
                    }
                case false:
                    print("fail to Request: \(#function)")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            UIView.animate(withDuration: 0.3) { strongSelf.v.start(false) }
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
            guard let strongSelf = self  else {
                return
            }
            switch result {
            case .success(let response):
                switch (200...299) ~= response.statusCode {
                case true : strongSelf.navigationController?.popViewController(animated: true)
                case false: Square.display("Alredy exist input username")
                }
                
            case .failure(let error): print(error.localizedDescription)
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
    
    @objc func didChangeTextField(_ textfield: SkyFloatingLabelTextField) {
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
