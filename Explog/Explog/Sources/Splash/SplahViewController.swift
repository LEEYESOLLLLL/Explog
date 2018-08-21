//
//  ViewController.swift
//  Explog
//
//  Created by minjuniMac on 8/21/18.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

class SplahViewController: BaseViewController {

    lazy var v = SplahView(controlBy: self)
    
    override func loadView() {
        view = v
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
}

