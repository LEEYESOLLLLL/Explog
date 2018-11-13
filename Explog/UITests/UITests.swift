//
//  UITests.swift
//  UITests
//
//  Created by minjuniMac on 10/11/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import XCTest

class UITests: XCTestCase {

    let app = XCUIApplication()
    override func setUp() {
        super.setUp()
        setupSnapshot(app)
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
        app.terminate()
    }
    
    func test_for_MainScreen() {
        XCUIApplication().scrollViews.otherElements.scrollViews.otherElements.buttons["Europe"].tap()
        // main screen
        snapshot("0_Main_Screen")
    }
    
    func test_for_PostingScreen() {
        let elementsQuery = XCUIApplication().scrollViews.otherElements.scrollViews.otherElements
        elementsQuery.buttons["Europe"].tap()
        elementsQuery.tables/*@START_MENU_TOKEN@*/.staticTexts["2018-10-07 ~ 2018-11-07"]/*[[".cells.staticTexts[\"2018-10-07 ~ 2018-11-07\"]",".staticTexts[\"2018-10-07 ~ 2018-11-07\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        snapshot("1_Posting_Scrren")

    }

    func test_for_ReplyScrren() {
        let elementsQuery = XCUIApplication().scrollViews.otherElements.scrollViews.otherElements
        elementsQuery.buttons["Europe"].tap()
        elementsQuery.tables/*@START_MENU_TOKEN@*/.staticTexts["아름다운 스위스 여행기✨"]/*[[".cells.staticTexts[\"아름다운 스위스 여행기✨\"]",".staticTexts[\"아름다운 스위스 여행기✨\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Feed"].children(matching: .button).element(boundBy: 1).tap()
        snapshot("2_Reply_Sceen")
    }

    func test_for_CreatingPostScreen() {
        app.tabBars.buttons["Post"].tap()
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons["  Cover"].tap()
        app.collectionViews.children(matching: .cell).element(boundBy: 1).children(matching: .other).element.tap()
        app.navigationBars["Camera Roll"].buttons["Done"].tap()
        elementsQuery.buttons["checkBox"].tap()
        
        snapshot("3_Creating_Post_Screen")

    }
}
