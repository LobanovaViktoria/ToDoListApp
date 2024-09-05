//
//  ToDoListAppTests.swift
//  ToDoListAppTests
//
//  Created by Viktoria Lobanova on 05.09.2024.
//

import XCTest
@testable import ToDoListApp

final class ToDoListAppTests: XCTestCase {
    
    let validResponse = """
{
    "todos": [
        {
            "id": 1,
            "todo": "Do something nice for someone you care about",
            "completed": false,
            "userId": 152
        },
        {
            "id": 2,
            "todo": "Memorize a poem",
            "completed": true,
            "userId": 13
        }
    ],
    "total": 254,
    "skip": 0,
    "limit": 30
}
"""
    
let invalidResponse = """
{
    "todos": [
        {
            "id": 1,
            "todo": "Do something nice for someone you care about",
            "completed": false,
            "userId": 152
        },
        {
            "id": 2,
            "todo": "Memorize a poem",
            "completed": true,
            "userId": "13"
        }
    ],
    "total": 254,
    "skip": 0,
    "limit": 30
}
""" // userId строка

let invalidResponse2 = """
{
    "todos": [
        {
            "id": 1,
            "todo": "Do something nice for someone you care about",
            "completed": false,
            "userId": 152
        },
        {
            "id": 2,
            "todo": "Memorize a poem",
            "complеted": true,
            "userId": 13
        }
    ],
    "total": 254,
    "skip": 0,
    "limit": 30
}
""" // completed содержит русскую "е"

    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        
    }
    
    func testValidResponseDecoding() {
        guard let data = validResponse.data(using: .utf8) else {
            XCTFail("Invalid string")
            return
        }
        let decoder = JSONDecoder()
        XCTAssertNoThrow(try decoder.decode(Welcome.self, from: data), "Wrong response format")
    }
    
    func testInValidResponseDecoding() {
        guard let data = invalidResponse.data(using: .utf8) else {
            XCTFail("Invalid string")
            return
        }
        let decoder = JSONDecoder()
        XCTAssertThrowsError(try decoder.decode(Welcome.self, from: data))
    }
    
    func testInValidResponse2Decoding() {
        guard let data = invalidResponse2.data(using: .utf8) else {
            XCTFail("Invalid string")
            return
        }
        let decoder = JSONDecoder()
        XCTAssertThrowsError(try decoder.decode(Welcome.self, from: data))
    }
}
