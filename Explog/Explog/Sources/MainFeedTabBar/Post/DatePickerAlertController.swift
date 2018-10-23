//
//  DatePickerAlertController.swift
//  Explog
//
//  Created by minjuniMac on 23/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

final class DatePickerAlertController: UIAlertController {
    var datePicker = UIDatePicker().then {
        $0.datePickerMode = .date
    }
    var readableDate: String {
        return datePicker.date.convertedString()
    }
    /**
     must check out to use this convenience initialization when initializing
     */
    convenience init(preferredStyle: UIAlertController.Style) {
        self.init(title: "\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: preferredStyle)
        datePicker.addTarget(self,
                             action: #selector(datepickerAction(_:)),
                             for: .valueChanged)
        setupUI()
    }
    
    func setupUI() {
        view.addSubview(datePicker)
        datePicker
            .topAnchor(to: view.topAnchor)
            .centerXAnchor(to: view.centerXAnchor)
            .activateAnchors()
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        addAction(cancelAction)
    }
    @objc func datepickerAction(_ sender: UIDatePicker) { }
}


