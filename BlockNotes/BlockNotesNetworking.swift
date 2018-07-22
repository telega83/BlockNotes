//
//  BlockNotesNetworking.swift
//  BlockNotes
//
//  Created by Oleg on 19/07/2018.
//  Copyright © 2018 telega. All rights reserved.
//

import Foundation

class BlockNotesNetworking {
    private let _url = "https://private-9aad-note10.apiary-mock.com/"
    
    init() {
        
    }
    
    func sendGetRequest(request: String, completion: @escaping (Data?) -> ()) {
        let url = URL(string: "\(_url)\(request)")!
        let session = URLSession.shared
        
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                print("\(error.localizedDescription)")
                return completion(nil)
            } else if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    print("\(response.statusCode)")
                    return completion(nil)
                } else {
                    if let data = data {
                        return completion(data)
                    }
                }
            }
        }.resume()
    }
    
    func sendPostRequest(completion: @escaping (URLResponse?, Data?) -> ()) {
        let url = URL(string: "\(_url)/notes")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\n  \"title\": \"\"\n}".data(using: .utf8)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("\(error.localizedDescription)")
                return completion(nil, nil)
            } else if let response = response, let data = data {
                return completion(response, data)
                
            }
        }
        task.resume()
    }
    
    func sendPutRequest(id: Int, text: String, completion: @escaping (URLResponse?, Data?) -> ()) {
        let url = URL(string: "\(_url)notes/\(id)")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\n  \"title\": \"\(text)\"\n}".data(using: .utf8)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("\(error.localizedDescription)")
                return completion(nil, nil)
            } else if let response = response, let data = data {
                return completion(response, data)
                
            }
        }
        task.resume()
    }
    
    func sendDeleteRequest(id: Int, completion: @escaping (URLResponse?, Data?) -> ()) {
        let url = URL(string: "\(_url)notes/\(id)")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("\(error.localizedDescription)")
                return completion(nil, nil)
            } else if let response = response, let data = data {
                return completion(response, data)
                
            }
        }
        task.resume()
    }
}
