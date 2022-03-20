//
//  Credentials.swift
//  tasker
//
//  Created by Kevin Babou on 3/19/22.
//

import Foundation

struct Credentials {
    static let server = "www.firebase.google.com"
    var username: String
    var password: String
}

enum KeychainError: Error {
    case noPassword
    case unexpectedPasswordData
    case unhandledError(status: OSStatus)
}


