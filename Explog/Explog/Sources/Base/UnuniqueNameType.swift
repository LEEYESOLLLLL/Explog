//
//  Identifierable.swift
//  Explog
//
//  Created by Minjun Ju on 01/12/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import Foundation

// identifiable
protocol UnuniqueNameType: AnyObject {
    var unUniqueIdentifier: String { get }
}

extension UnuniqueNameType {
    var unUniqueIdentifier: String {
        return String(describing: type(of:self)) // Warning: Shouldn't use `String(describing: self)`
    }
}
