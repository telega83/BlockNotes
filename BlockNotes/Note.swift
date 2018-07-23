//
//  Note.swift
//  BlockNotes
//
//  Created by Oleg on 19/07/2018.
//  Copyright © 2018 telega. All rights reserved.
//

import Foundation

class Note: Codable {
    private var _id: Int
    private var _date: Date?
    private var _text: String
    
    private enum CodingKeys : String, CodingKey {
        case _id = "id"
        case _text = "title"
    }
    
    var id: Int {
        get {
            return _id
        }
    }
    
    var date: Date? {
        get {
            return _date
        }
    }
    
    var text: String {
        get {
            return _text
        }
        set {
            _text = newValue
        }
    }
    
    init(id: Int, text: String) {
        _id = id
        _text = text
        _date = Date()
    }
    
}
