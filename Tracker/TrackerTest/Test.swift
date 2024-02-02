//
//  test.swift
//  TrackerTests
//
//  Created by Георгий Ксенодохов on 02.02.2024.
//

import XCTest
import SnapshotTesting

@testable import Tracker


final class Test: XCTestCase {

    func testViewController() {
        let view = TrackersViewController()
        assertSnapshot(matching: view, as: .image(traits: UITraitCollection(userInterfaceStyle: .light)))
    }
    
    func testViewCOntrollerDarkTheme() {
        let view = TrackersViewController()
        assertSnapshot(matching: view, as: .image(traits: UITraitCollection(userInterfaceStyle: .dark)))
    }
}
