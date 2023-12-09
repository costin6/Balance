//
//  ios_individual_case_costin_burlacioiuUITestsLaunchTests.swift
//  ios-individual-case-costin-burlacioiuUITests
//
//  Created by Costin Burlacioiu on 26/09/2023.
//

import XCTest

final class ios_individual_case_costin_burlacioiuUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
