//
//  CautionViewController.swift
//  Explog
//
//  Created by Minjun Ju on 13/11/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

final class CautionViewController: BaseViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    lazy var v = CautionView(controlBy: self)
    
    init(modalStyle: UIModalPresentationStyle) {
        super.init()
        self.modalPresentationStyle = modalStyle
    }
    
    required init() { fatalError("init() has not been implemented") }
    
    required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented")
    }
    override func loadView() {
        super.loadView()
        view = v
    }
}

extension CautionViewController {
    @objc func dismissButtonAction(_ sender: UIButton) {
        Persistence.setValue(true)
        dismiss(animated: true, completion: nil)
    }
}

extension CautionViewController: UITextViewDelegate {
    
}
