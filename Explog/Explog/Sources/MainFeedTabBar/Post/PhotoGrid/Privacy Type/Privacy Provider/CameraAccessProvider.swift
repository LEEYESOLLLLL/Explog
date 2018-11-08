//
//  CameraAccessProvider.swift
//  Explog
//
//  Created by minjuniMac on 08/11/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import Foundation
import AVFoundation

class CameraAccessProvider: PrivateAccessProvider {
    var accessLevel: PrivateAccessLevel {
        return AVCaptureDevice.authorizationStatus(for: .video).accessLevel
    }
    
    func requestAccess(completionHandler: @escaping (PrivateRequestAccessResult) -> Void) {
        AVCaptureDevice.requestAccess(for: .video) { _ in
            DispatchQueue.main.async {
                completionHandler(PrivateRequestAccessResult(self.accessLevel))
            }
        }
    }
}

extension AVAuthorizationStatus: PrivateAccessLevelConvertible {
    var accessLevel: PrivateAccessLevel {
        switch self {
        case .authorized:    return .granted
        case .denied:        return .denied
        case .notDetermined: return .undetermined
        case .restricted:    return .restricted
        }
    }
}


