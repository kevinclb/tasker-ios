//
//  Conversation.swift
//  tasker
//
//  Created by Jeffrey Viramontes on 4/28/22.
//

import Foundation
import FirebaseFirestoreSwift

class Conversation: Codable {
    @DocumentID var docID: String?
    var user1ID: String
    var user2ID: String
    var messages: [Message]
    
    init(user1ID: String, user2ID: String, messages: [Message])
    {
        self.user1ID = user1ID
        self.user2ID = user2ID
        self.messages = messages
    }
    
    init()
    {
        self.user1ID = ""
        self.user2ID = ""
        self.messages = [Message.init()]
    }
}
