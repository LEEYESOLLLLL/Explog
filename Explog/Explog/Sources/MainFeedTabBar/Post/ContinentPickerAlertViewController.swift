//
//  ContinentPickerAlertViewController.swift
//  Explog
//
//  Created by minjuniMac on 23/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

final class ContinentPickerAlertViewController: UIAlertController {
    // VC에서 받아야 하는것은 Picker에서 선택한 Continent, OK Action 이후에
    var pickerView = UIPickerView()
    
    convenience init(preferredStyle: UIAlertController.Style) {
        self.init(title: "\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: preferredStyle)
        setupUI()
        setupBinding()
    }
    
    
    func setupUI() {
        view.addSubview(pickerView)
        pickerView
            .topAnchor(to: view.topAnchor)
            .centerXAnchor(to: view.centerXAnchor)
            .activateAnchors()
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        addAction(cancelAction)
    }
    
    func setupBinding() {
        pickerView.delegate = self
        pickerView.dataSource = self
    }
}

//case "Aisa":
//return "1"
//case "Europe":
//return "2"
//case "North America":
//return "3"
//case "South America":
//return "4"
//case "Africa":
//return "5"
//case "Oceania":
//return "6"
//default:
//return "1"
//}

extension ContinentPickerAlertViewController {
    enum ContinentType: Int, CaseIterable {
        case asia = 0
        case europe
        case northAmerica
        case southAmerica
        case africa
        case oceania
        
        var string: String {
            switch self {
            case .asia: return "Asia"
            case .europe: return "Europe"
            case .northAmerica: return "North America"
            case .southAmerica: return "South America"
            case .africa: return "Africa"
            case .oceania: return "Oceania"
            }
        }
    }
}

extension ContinentPickerAlertViewController: UIPickerViewDelegate {
    
}

extension ContinentPickerAlertViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ContinentType.allCases.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ContinentType.allCases[row].string
    }
    
    
    
}

