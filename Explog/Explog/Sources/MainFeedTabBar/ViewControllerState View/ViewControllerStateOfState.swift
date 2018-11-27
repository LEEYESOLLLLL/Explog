//
//  ViewControllerStateOfState.swift
//  Explog
//
//  Created by Minjun Ju on 27/11/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

extension ViewControllerStateView {
    enum State  {
        case loading
        case error
        case empty
        case initial
        case retryOnError(owner: UIViewController, selector: Selector)
    }
}
