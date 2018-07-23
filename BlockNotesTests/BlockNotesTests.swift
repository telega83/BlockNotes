//
//  BlockNotesTests.swift
//  BlockNotesTests
//
//  Created by Oleg on 19/07/2018.
//  Copyright © 2018 telega. All rights reserved.
//

import XCTest
@testable import BlockNotes

class BlockNotesTests: XCTestCase {
    var testModel: BlockNotesModel!
    
    override func setUp() {
        super.setUp()
        testModel = BlockNotesModel()
    }
    
    override func tearDown() {
        super.tearDown()
        testModel = nil
    }
    
    //One note has been received
    func testNoteAddedFromJSON() {
        let json = "{\n  \"id\": 1, \"title\": \"Jogging in park\"\n}".data(using: .utf8)!
        _ = testModel.addNote(json: json)
        XCTAssert(testModel.getNoteCount() == 1, "Notes created: \(testModel.getNoteCount()), expected: 1")
        XCTAssert(testModel.getNote(index: 0)?.id == 1, "note[0].id = \(String(describing: testModel.getNote(index: 0)?.id)), expected: 1")
        XCTAssert(testModel.getNote(index: 0)?.text == "Jogging in park", "note[0].text = \(String(describing: testModel.getNote(index: 0)?.text)), expected: Jogging in park")
    }
    
    //Array of notes has been received
    func testNotesAddedFromJSON() {
        let json = "[{\n  \"id\": 1, \"title\": \"Jogging in park\"\n}, {\n  \"id\": 2, \"title\": \"Pick-up posters from post-office\"\n}]".data(using: .utf8)!
        _ = testModel.addNote(json: json)
        XCTAssert(testModel.getNoteCount() == 2, "Notes created: \(testModel.getNoteCount()), expected: 2")
        XCTAssert(testModel.getNote(index: 0)?.id == 1, "note[0].id = \(String(describing: testModel.getNote(index: 0)?.id)), expected: 1")
        XCTAssert(testModel.getNote(index: 0)?.text == "Jogging in park", "note[0].text = \(String(describing: testModel.getNote(index: 0)?.text)), expected: Jogging in park")
        XCTAssert(testModel.getNote(index: 1)?.id == 2, "note[0].id = \(String(describing: testModel.getNote(index: 1)?.id)), expected: 2")
        XCTAssert(testModel.getNote(index: 1)?.text == "Pick-up posters from post-office", "note[0].text = \(String(describing: testModel.getNote(index: 1)?.text)), expected: Pick-up posters from post-office")
    }

}
