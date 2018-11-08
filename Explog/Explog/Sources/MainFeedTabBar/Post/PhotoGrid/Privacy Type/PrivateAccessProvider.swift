//
//  PrivateAccessResult.swift
//  Explog
//
//  Created by minjuniMac on 08/11/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import Foundation

typealias PrivateAccessProvider = PrivateDataAccessStatusProvider & PrivateAccessRequestProvider
protocol PrivateDataAccessStatusProvider {
    var accessLevel: PrivateAccessLevel { get }
}

/**
 `PrivateAccessRequestProvider` defines an interface for requesting access to a user's private data, regardless of the data type.
 */
protocol PrivateAccessRequestProvider {
    /// A typealias describing the completion handler used when requesting access to private data.
    func requestAccess(completionHandler: @escaping (PrivateRequestAccessResult) -> Void)
}

enum PrivacyType: String, Localizable {
    case camera        = "SERVICE_CAMERA"
    case photosLibrary = "SERVICE_PHOTO_LIBRARY"
    
    func localizedValue() -> String {
        return NSLocalizedString(self.rawValue, comment: "Table View cell label for \(self.rawValue)")
    }
    
    var providing: PrivateAccessProvider {
        switch self {
        case .camera:
            return CameraAccessProvider()
        case .photosLibrary:
            return PhotoAccessProvider()
        }
    }
}

struct PrivateDataAccessActions {
    let dataType: PrivacyType
    var accessStatusAction: PrivateDataAccessStatusProvider
    var requestAccessAction: PrivateAccessRequestProvider
    
    init(for type: PrivacyType) {
        dataType = type
        accessStatusAction = type.providing as PrivateDataAccessStatusProvider
        requestAccessAction = type.providing as PrivateAccessRequestProvider
    }
}

