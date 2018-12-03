//
//  UITests.swift
//  UITests
//
//  Created by minjuniMac on 10/11/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import XCTest
import Localize_Swift

@testable
import Explog

class UITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        app.launchArguments += ["-AppleLanguages", "\(Localize.resetCurrentLanguageToDefault())"]
//        app.launchArguments += ["-AppleLocale", "en_US"]
        setupSnapshot(app)
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
        app.terminate()
    }
    
    func test_for_MainScreen() {
        // main screen
        XCUIApplication().scrollViews.otherElements.scrollViews.otherElements.buttons["Europe".localized()].tap()
        snapshot("0_Main_Screen")
    }
    
    func test_for_PostingScreen() {
        let elementsQuery = XCUIApplication().scrollViews.otherElements.scrollViews.otherElements
        elementsQuery.buttons["Europe".localized()].tap()
        elementsQuery.tables/*@START_MENU_TOKEN@*/.staticTexts["2018-11-01 ~ 2018-11-03"]/*[[".cells.staticTexts[\"2018-11-01 ~ 2018-11-03\"]",".staticTexts[\"2018-11-01 ~ 2018-11-03\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        snapshot("1_Posting_Scrren")
    }

    func test_for_ReplyScrren() {
        let elementsQuery = app.scrollViews.otherElements.scrollViews.otherElements
        elementsQuery.buttons["Europe".localized()].tap()
        elementsQuery.tables/*@START_MENU_TOKEN@*/.staticTexts["2018-11-01 ~ 2018-11-03"]/*[[".cells.staticTexts[\"2018-11-01 ~ 2018-11-03\"]",".staticTexts[\"2018-11-01 ~ 2018-11-03\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Feed".localized()].children(matching: .button).element(boundBy: 1).tap()
        snapshot("2_Reply_Sceen")
    }

    func test_for_CreatingPostScreen() {
        app.tabBars.buttons["Post"].tap()
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons["  Cover"].tap()
        app.collectionViews.children(matching: .cell).element(boundBy: 1).children(matching: .other).element.tap()
        app.navigationBars["Camera Roll"].buttons["Done"].tap()
        elementsQuery.buttons["checkBox"].tap()
        app.staticTexts["+"].tap()
        snapshot("3_Creating_Post_Screen")
    }
}
