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
}

struct PrivateDataAccessActions {
    let dataType: PrivacyType
    var accessStatusAction: PrivateDataAccessStatusProvider
    var requestAccessAction: PrivateAccessRequestProvider
    
    init(for type: PrivacyType) {
        var selectedActions: AnyObject? = nil
        dataType = type
        
        switch type {
        case .camera:
            selectedActions = CameraAccessProvider()
        case .photosLibrary:
            selectedActions = PhotoAccessProvider()
        }
        
        guard let accessAction = selectedActions as? PrivateDataAccessStatusProvider,
            let requestAction = selectedActions as? PrivateAccessRequestProvider else {
                fatalError()
        }
        accessStatusAction = accessAction
        requestAccessAction = requestAction
    }
}

