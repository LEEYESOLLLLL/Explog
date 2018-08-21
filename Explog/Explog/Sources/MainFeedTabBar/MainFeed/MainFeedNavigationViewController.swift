//
//  MainFeedNavigationViewController.swift
//  Explog
//
//  Created by minjuniMac on 8/21/18.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

final class MainFeedViewController: BaseViewController {
    lazy var v = MainFeedView(controlBy: self)
    
    override func loadView() {
        view = v
    }
    
    @objc func buttonAction(_ sender: UIButton) {
        navigationController?.pushViewController(MainFeedViewController(), animated: true)
        
    }
}
