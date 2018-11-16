//
//  ReportList.swift
//  Explog
//
//  Created by Minjun Ju on 16/11/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

extension ReportViewController {
    enum ReportList: String, CaseIterable {
        case pornography = "Pornography"
        case expletives  = "Expletives"
        case slander     = "Content that defames someone"
        case unpleasant  = "content that is unpleasant"
        case etc         = "Etc."
    }    
}

extension ReportViewController {
    struct ReportModel {
        var postPK: Int
        var reportType: String
        init(_ postPK: Int, _ reportType: String) {
            self.postPK = postPK
            self.reportType = reportType
        }
        
        func dictionary() -> [String: Any] {
            return ["postPK": postPK,
                    "date": Date().convertedNow(),
                    "report_type": reportType
            ]
        }
    }
}
extension ReportViewController {
    enum FBDatabaseKey: String, CaseIterable{
        case report = "reports"
    }
}
