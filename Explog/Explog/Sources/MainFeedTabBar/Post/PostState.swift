//
//  PostState.swift
//  Explog
//
//  Created by minjuniMac on 23/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit


extension PostViewController {
    /**
     state for textViewDidChange Delegate method at PostViewController
     */
    enum EditableTextView {
        case enable
        case disable
        init(state: Bool) {
            self = state ? .enable : .disable
        }
    }
}

extension PostViewController {
    enum TripDateType: Int {
        case start = 0
        case end
    }
}



