//
//  PostViewController.swift
//  Explog
//
//  Created by minjuniMac on 8/21/18.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

import UIKit

final class PostViewController: BaseViewController {
    static func create() -> UINavigationController {
        let `self` = self.init()
        self.title = "Post"
        self.tabBarItem.image = #imageLiteral(resourceName: "create_post")
        let navigationController = UINavigationController(rootViewController: self)
        navigationController.setNavigationBarHidden(true, animated: false)
        return navigationController
    }
    
    lazy var v = PostView(controlBy: self)
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func loadView() {
        super.loadView()
        view = v
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    @objc func dismissButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func createPostButtonAction(_ sender: UIButton) {
        // Network request
        // required, coverImage, title, date(start, end), contienet
        
    }
    
    @objc func changeCoverImageButtonAction(_ sender: UIButton) {
        // ImagePicker 로할건지 Photo 라이브러리로 할건지..
        
    }
    
    @objc func dateButtonAction(_ sender: UIButton) {
        guard let buttonType = TripDateType(rawValue: sender.tag) else {
            return
        }
        let datepickerAlertController = DatePickerAlertController(preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard let strongSelf = self,
                let pickDate = datepickerAlertController.readableDate.convertDate() else {
                    return
            }
            var compairableResult: Bool = false
            switch buttonType {
            case .start:
                // endTitleLabel
                if let endTitleLable = strongSelf.v.endDateButton.titleLabel,
                    let endTitleLabelDate = endTitleLable.text?.convertDate() {
                    compairableResult = pickDate > endTitleLabelDate ? false : true
                }
            case .end:
                // startTitleLabel
                if let startTitleLabel = strongSelf.v.startDateButton.titleLabel,
                    let startTitleLabelDate = startTitleLabel.text?.convertDate() {
                    compairableResult = pickDate < startTitleLabelDate ? false : true
                }
            }
            if compairableResult {
                sender.setTitle(pickDate.convertedString(), for: [.normal, .highlighted])
            } else {
                UIAlertController.showWithAlertAction(
                    alertVCtitle: "Start Date can't be later than End Date or End Date can't be earlier than Start Date",
                    alertVCmessage: "",
                    alertVCstyle: .alert,
                    isCancelAction: false,
                    actionTitle: "OK",
                    actionStyle: .default,
                    action: nil)
            }
        }
        datepickerAlertController.addAction(okAction)
        present(datepickerAlertController, animated: true, completion: nil)
    }
    
    // 대륙 상태 관리 요망. 1~6 맵핑 필요
    @objc func continentButtonAction(_ sender: UIButton){
        let continentPickerAlertController = ContinentPickerAlertViewController(preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        continentPickerAlertController.addAction(okAction)
        present(continentPickerAlertController, animated: true, completion: nil)
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


