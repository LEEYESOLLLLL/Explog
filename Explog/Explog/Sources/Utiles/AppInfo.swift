//
//  AppInfo.swift
//  Explog
//
//  Created by minjuniMac on 01/11/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import AVFoundation
import Moya
import SwiftyBeaver

class AppInfo {
    static let provider = MoyaProvider<AppVersion>()//(plugins:[NetworkLoggerPlugin()])
    /// Returns DEBUG or RELEASE info with version and build number
    static func buildInfo() -> String {
        #if DEBUG
        return "DEBUG" + versionInfo()
        #else
        return "RELEASE" + versionInfo()
        #endif
    }
    
    /// Returns Version Info - Version Number & Build Number
    static func versionInfo() -> String {
        return " v " + self.versionString() + " b " + buildString()
    }
    /// Returns Version Info - Version Number
    static func versionString() -> String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    }
    /// Returns Version Info - Build Number
    static func buildString() -> String {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as! String
    }
    /// Returns App Name
    static func appName() -> String {
        return Bundle.main.infoDictionary?["CFBundleName"] as! String
    }
    
    /// Returns Api Version Number
    /// Runtime error, now 
    static func apiVersionNumber() -> String {
        return Bundle.main.infoDictionary?["API_VERSION"] as! String
    }
    
    static var outputVolume: Float {
        return AVAudioSession.sharedInstance().outputVolume
    }
    
    static var outputVolDB: Float {
        return 20.0 * log10f(AppInfo.outputVolume + .leastNormalMagnitude)
    }
}

extension AppInfo {
    static var developerEmail: String {
        return "dev.mjun@gmail.com"
    }
    
    static var feedbackSubject: String {
        return "[Explog] FeedBack for!"
    }
    static var feedbackBody: String {
        return "" 
    }
    static var current_device_version: String {
        return UIDevice.current.systemVersion
    }
}

extension AppInfo {
    static func latest(version: @escaping (String) -> Void)   {
        provider.request(.latest) { (result) in
            switch result {
            case .success(let response):
                guard let appInfoModel = try? response.map(AppInfoModel.self),
                    let model = appInfoModel.results.first else {
                        SwiftyBeaver.error("fail to convert model(AppInfoModel)")
                    return
                }
                version(model.version)
            case .failure(let error):
                SwiftyBeaver.error(error)
            }
        }
    }
}

