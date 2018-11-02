//
//  File.swift
//  Explog
//
//  Created by minjuniMac on 01/11/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import MessageUI

extension MFMailComposeViewController {
    static func create<T: MFMailComposeViewControllerDelegate>(owner: T) -> Self {
        let `self` = self.init()
        self.mailComposeDelegate = owner
        self.setToRecipients([AppInfo.developerEmail])
        self.setSubject(AppInfo.feedbackSubject)
        self.setMessageBody(String(format:NSLocalizedString("\nThanks for your feedback! \n Please, write your advise here \n\n\niOS version: %@ \nApp version: %@", comment: ""), AppInfo.current_device_version ,AppInfo.versionString()) , isHTML: false)
        return self
        
    }
}
