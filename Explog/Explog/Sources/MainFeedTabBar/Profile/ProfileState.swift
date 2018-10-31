//
//  ProfileState.swift
//  Explog
//
//  Created by minjuniMac on 31/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

extension ProfileViewController {
    enum EditMode {
        case on
        case off
    }
}

extension ProfileViewController {
    enum State {
        case loading
        case ready(item: UserModel)
    }
}
