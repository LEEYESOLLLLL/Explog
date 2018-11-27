//
//  PostViewController.swift
//  Explog
//
//  Created by minjuniMac on 8/21/18.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import Moya
import Square
import SwiftyBeaver
import Localize_Swift

final class PostViewController: BaseViewController {
    static func create() -> UINavigationController {
        let `self` = self.init()
        self.title = "Post".localized()
        self.tabBarItem.image = #imageLiteral(resourceName: "create_post")
        let navigationController = UINavigationController(rootViewController: self)
        navigationController.setNavigationBarHidden(true, animated: false)
        return navigationController
    }
    
    lazy var v = PostView(controlBy: self)
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let provider = MoyaProvider<Post>()//(plugins: [NetworkLoggerPlugin()])
    override func loadView() {
        super.loadView()
        view = v
    }
}

// MARK: Repeat execution
extension PostViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = nil
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !Persistence.isConfirm {
            present(CautionViewController(modalStyle: .overCurrentContext), animated: true, completion: nil)
        }
    }
    
    @objc func dismissButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: Networking action
extension PostViewController {
    @objc func createPostButtonAction(_ sender: UIButton) {
        guard let currentPostCoverInformation = v.currentPostCoverInformation() else { return }
        provider.request(.post(title: currentPostCoverInformation.title,
                               startDate: currentPostCoverInformation.startData,
                               endDate: currentPostCoverInformation.endData,
                               continent: currentPostCoverInformation.continent,
                               img: currentPostCoverInformation.coverImg)) { [weak self] result in
                                guard let self = self else {
                                    return
                                }
                                
                                switch result {
                                case .success(let response):
                                    switch (200...299) ~= response.statusCode {
                                    case true :
                                        guard let coverData = try? response.map(PostCoverModel.self) else {
                                            SwiftyBeaver.warning("Not Converting PostCoverModel")
                                            return
                                        }
                                        
                                        let detailVC = PostDetailViewController.create(editMode: .on, coverData: coverData)
                                        self.show(detailVC, sender: nil)
                                    case false:
                                        SwiftyBeaver.warning("Fast to Reqeust")
                                    }
                                    
                                case .failure(let error):
                                    SwiftyBeaver.error("Weak Internet Connection: \(error)")
                                }
        }
    }
    
    @objc func changeCoverImageButtonAction(_ sender: UIButton) {
        let photoGridViewController = PhotoGridViewController.create()
        photoGridViewController.delegate = self
        
        let naviVC = UINavigationController(rootViewController: photoGridViewController)
        naviVC.setNavigationBarHidden(false, animated: true)
        present(naviVC, animated: true, completion: nil)
    }
    
    @objc func dateButtonAction(_ sender: UIButton) {
        guard let buttonType = TripDateType(rawValue: sender.tag) else {
            return
        }
        let datepickerAlertController = DatePickerAlertController(preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "OK".localized(), style: .default) { [weak self] _ in
            guard let self = self,
                let pickDate = datepickerAlertController.readableDate.convertDate() else {
                    return
            }
            var compairableResult: Bool = false
            switch buttonType {
            case .start:
                // endTitleLabel
                if let endTitleLable = self.v.endDateButton.titleLabel,
                    let endTitleLabelDate = endTitleLable.text?.convertDate() {
                    compairableResult = pickDate > endTitleLabelDate ? false : true
                }
            case .end:
                // startTitleLabel
                if let startTitleLabel = self.v.startDateButton.titleLabel,
                    let startTitleLabelDate = startTitleLabel.text?.convertDate() {
                    compairableResult = pickDate < startTitleLabelDate ? false : true
                }
            }
            
            switch compairableResult {
            case true :  sender.setTitle(pickDate.convertedString(), for: [.normal, .highlighted])
            case false : Square.display("Start Date can't be later than End Date or End Date can't be earlier than Start Date".localized())
            }
        }
        datepickerAlertController.addAction(okAction)
        present(datepickerAlertController, animated: true, completion: nil)
    }
}
extension PostViewController: PassableDataDelegate {
    @objc func continentButtonAction(_ sender: UIButton){
        let continentPickerAlertController = ContinentPickerAlertViewController(preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "OK".localized(), style: .default) { [weak continentPickerAlertController] _ in
            guard let strongContinentPickerAlertController = continentPickerAlertController,
                let continent = strongContinentPickerAlertController.passContinent else {
                    return
            }
            sender.setTitle(continent(), for: [.normal, .highlighted])
        }
        continentPickerAlertController.addAction(okAction)
        present(continentPickerAlertController, animated: true, completion: nil)
    }
    
    func pass(data: UIImage) {
        DispatchQueue.main.async {
            self.v.coverImageView.image = data
        }
    }
}


extension PostViewController: UITextViewDelegate {
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textView.text = ""
        return true
    }
    func textViewDidChange(_ textView: UITextView) {
        let state = EditableTextView(state: (0...50) ~= textView.text.count)
        switch state {
        case .enable:
            let copy = textView.text.trimmingCharacters(in: .newlines)
            let textCount = String(textView.text.count)
            textView.text = copy
            v.updateTitleCouterLable(text: textCount, color: .white)
        case .disable :
            let copy = String(textView.text.dropLast())
            textView.text = copy
            v.updateTitleCouterLable(text: "50", color: .red)
        }
    }
}


