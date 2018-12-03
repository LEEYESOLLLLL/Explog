//
//  AppInfoModel.swift
//  Explog
//
//  Created by Minjun Ju on 26/11/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

struct AppInfoModel: Decodable {
    var results: [Results]
}

extension AppInfoModel {
    struct Results: Decodable {
        var version: String
    }
}
