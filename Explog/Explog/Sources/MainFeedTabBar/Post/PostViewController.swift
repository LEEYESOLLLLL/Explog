//
//  PostViewController.swift
//  Explog
//
//  Created by minjuniMac on 8/21/18.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

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
    
    // startDate는 endDate보다 뒤로갈수 없음
    @objc func startDateButtonAction(_ sender: UIButton) {
        
    }
    
    // endDate는 startDate보다 앞 일수없음
    @objc func endDateButtonAction(_ sender: UIButton) {
        
    }
    
    // 대륙 상태 관리 요망. 1~6 맵핑 필요
    @objc func continentButtonAction(_ sender: UIButton){
        
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

