//
//  SwiftyBeaver+AddDestination.swift
//  Explog
//
//  Created by MinjunJu on 22/11/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import Foundation
import SwiftyBeaver

extension SwiftyBeaver {
    static func  addDestinations(_ destinations: [BaseDestination]) {
        for destination in destinations {
            addDestination(destination)
        }
    }
}
