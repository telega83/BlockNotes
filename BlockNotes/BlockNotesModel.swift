//
//  BlockNotesModel.swift
//  BlockNotes
//
//  Created by Oleg on 19/07/2018.
//  Copyright © 2018 telega. All rights reserved.
//

import Foundation

class BlockNotesModel {
    
    private var _notes = [Note]()
    
    init(notes: [Note]) {
        _notes = notes
    }
    
    func addNote(note: Note) {
        _notes.append(note)
    }
    
    func addNote(note: [Note]) {
        _notes.append(contentsOf: note)
    }
    
    func addNote(json: Data) {
        do {
            addNote(note: try JSONDecoder().decode([Note].self, from: json))
        } catch {
            do {
                addNote(note: try JSONDecoder().decode(Note.self, from: json))
            } catch {
                print("JSON parsing error!")
            }
        }
    }
    
    func updateNote(id: Int, json: Data) {
        do {
            let update = try JSONDecoder().decode(Note.self, from: json)
            if let note = self.getNote(id: id){
                note.text = update.text
            }
        } catch {
            print("JSON parsing error!")
        }
    }
    
    func deleteNote(id: Int) {
        if let index = _notes.index(where: { $0.id == id }) {
            _notes.remove(at: index)
        }
    }
    
    func clearNotes() {
        _notes.removeAll()
    }
   
    func getNote(id: Int) -> Note? {
        let result = _notes.filter({ $0.id == id })
        if !result.isEmpty {
            return result.first
        } else {
            return nil
        }
    }
    
    func getNote(index: Int) -> Note? {
        if index >= 0 && index < _notes.count {
            return _notes[index]
        } else {
            return nil
        }
    }
    
    func getAllNotes() -> [Note] {
        return _notes
    }
    
    func getNoteCount() -> Int {
        return _notes.count
    }
    
}
