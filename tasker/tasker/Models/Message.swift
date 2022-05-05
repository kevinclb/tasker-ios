//
//  Message.swift
//  tasker
//
//  Created by Kevin Babou on 2/23/22.
//

import Foundation

class Message: Codable {
    var body: String
    var sender: String
    
    init(body: String, sender: String)
    {
        self.body = body
        self.sender = sender
    }
    
    init()
    {
        self.body = ""
        self.sender = ""
    }
}
