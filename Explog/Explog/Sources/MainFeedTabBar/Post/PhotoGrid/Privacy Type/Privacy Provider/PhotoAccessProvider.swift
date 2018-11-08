//
//  PhotoAccessProvider.swift
//  Explog
//
//  Created by minjuniMac on 08/11/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import Foundation
import Photos

class PhotoAccessProvider: NSObject, PrivateAccessProvider {
    var accessLevel: PrivateAccessLevel {
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        return authorizationStatus.accessLevel
    }
    
    func requestAccess(completionHandler: @escaping (PrivateRequestAccessResult) -> Void) {
        PHPhotoLibrary.requestAuthorization { (authorizationStatus) in
            DispatchQueue.main.async {
                completionHandler(PrivateRequestAccessResult(authorizationStatus.accessLevel))
            }
        }
    }
}

extension PHAuthorizationStatus: PrivateAccessLevelConvertible {
    var accessLevel: PrivateAccessLevel {
        switch self {
        case .authorized:    return .granted
        case .denied:        return .denied
        case .notDetermined: return .undetermined
        case .restricted:    return .restricted
        }
    }
}


