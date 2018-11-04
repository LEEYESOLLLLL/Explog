//
//  ReplyViewController.swift
//  Explog
//
//  Created by minjuniMac on 04/11/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

final class ReplyViewController: BaseViewController  {
    lazy var v = ReplyView(controlBy: self)
    override func loadView() {
        super.loadView()
        view = v 
    }
}
