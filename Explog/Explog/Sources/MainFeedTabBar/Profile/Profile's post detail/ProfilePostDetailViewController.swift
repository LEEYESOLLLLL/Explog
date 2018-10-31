//
//  ProfilePostDetailViewController.swift
//  Explog
//
//  Created by minjuniMac on 31/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

final class ProfilePostDetailViewController: PostDetailViewController {
    override func loadView() {
        super.loadView()
        view = ProfilePostDetailView(controlBy: self)
    }
    
    
    
    
}
