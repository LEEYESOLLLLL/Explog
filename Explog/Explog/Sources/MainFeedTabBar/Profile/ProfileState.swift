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
    // initial, populated, loading, error 
    enum State {
        case initial 
        case loading
        case populated(userModel: UserModel)
        case retryOnError
    }
}

enum LikeError: Error {
    case failConvertingModel
    case failRequesting
}
