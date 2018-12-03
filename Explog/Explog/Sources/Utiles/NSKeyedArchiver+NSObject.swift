//
//  NSKeyedArchiver+NSObject.swift
//  Explog
//
//  Created by Minjun Ju on 03/12/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

extension UIViewController {
    func copyNSObject<T: UIViewController>() throws -> T? {
        let copyData = try NSKeyedArchiver.archivedData(withRootObject: self)
        return try NSKeyedUnarchiver.unarchiveObject(with: copyData) as? T
    }
}
