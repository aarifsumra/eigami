//
//  LoginViewControllerUITests.swift
//  eigamiUITests
//
//  Created by aarif on 2018/03/12.
//

import XCTest

class LoginViewControllerUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testLoginSuccess() {
        let app = XCUIApplication()
        let enterYourEmailHereTextField = app.textFields["Enter your email here"]
        enterYourEmailHereTextField.tap()
        enterYourEmailHereTextField.typeText("user@example.com")
        
        let enterYourPasswordHereSecureTextField = app.secureTextFields["Enter your password here"]
        enterYourPasswordHereSecureTextField.tap()
        enterYourPasswordHereSecureTextField.typeText("password")
        app.buttons["Login"].tap()
        
        XCTAssertFalse(app.buttons["Login"].exists)
    }
    
    func testLoginFailer() {
        let app = XCUIApplication()
        let enterYourEmailHereTextField = app.textFields["Enter your email here"]
        enterYourEmailHereTextField.tap()
        enterYourEmailHereTextField.typeText("wronguser@example.com")
        
        let enterYourPasswordHereSecureTextField = app.secureTextFields["Enter your password here"]
        enterYourPasswordHereSecureTextField.tap()
        enterYourPasswordHereSecureTextField.typeText("wrongpassword")
        app.buttons["Login"].tap()
        
        addUIInterruptionMonitor(withDescription: "Login Failer") { (alert) -> Bool in
            alert.buttons["OK"].tap()
            return true
        }
        
        XCTAssertTrue(app.buttons["Login"].exists)
    }
    
}
