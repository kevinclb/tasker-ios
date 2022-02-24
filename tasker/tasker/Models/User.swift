//
//  User.swift
//  tasker
//
//  Created by Kevin Babou on 2/23/22.
//

import Foundation

struct User {
    var firstname: String
    var lastname: String
    var address: Address
    var email: String
    var password: String?  //TODO: Note. Passwords are string for temporary purposes only
                           //In production application, with actual users, never
                           //save password as unhashed, unencrypted strings!!!!
}
