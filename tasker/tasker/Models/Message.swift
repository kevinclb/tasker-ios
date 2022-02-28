//
//  Message.swift
//  tasker
//
//  Created by Kevin Babou on 2/23/22.
//

import Foundation

struct Message {
    var body: String
    var metadata: Metadata
    let sender: User
}


extension Message {
    struct Metadata {
        let date: Date
        var replySent: Bool
    }
}
