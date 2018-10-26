//
//  PostViewController.swift
//  Explog
//
//  Created by minjuniMac on 8/21/18.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import Moya


protocol PassableData: class {
    func pass(data: UIImage)
}

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
    
    let provider = MoyaProvider<Post>.init(plugins: [NetworkLoggerPlugin()])
    override func loadView() {
        super.loadView()
        view = v
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = nil
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    @objc func dismissButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func createPostButtonAction(_ sender: UIButton) {
        guard let currentPostCoverInformation = v.currentPostCoverInformation() else { return }
        provider.request(.post(
            title: currentPostCoverInformation.title,
            startDate: currentPostCoverInformation.startData,
            endDate: currentPostCoverInformation.endData,
            continent: currentPostCoverInformation.continent,
            img: currentPostCoverInformation.coverImg)) { [weak self] result in
                guard let strongSelf = self else { return }
                switch result {
                case .success(let response):
                    // 응답받은 전체 데이터 다음 ViewController에 넘겨주고, 해당 화면 그려주자.
                    // 다음 화면에 넘어갔을때 request 처리로 화면을 뿌려줄건지, cashed 된 값을 그대로 사용해줄건지 고민 해야함 
                    // pk 가지고 있어야함.
                    switch (200...299) ~= response.statusCode {
                    case true :
                        do {
                            let coverData = try response.map(PostCoverModel.self)
                            let detailVC = PostDetailViewController.create(coverData: coverData)
                            
                            strongSelf.show(detailVC, sender: nil)
                        }catch {
                            print("fail to convert Model: \(#function)")
                        }
                    case false:
                        print("fail to Request: \(#function)")
                        
                    }
                    
                case .failure(let error):
                    print("Serve Error: \(error.localizedDescription)")
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
}
extension PostViewController: PassableData {
    @objc func continentButtonAction(_ sender: UIButton){
        let continentPickerAlertController = ContinentPickerAlertViewController(preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak continentPickerAlertController] _ in
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


