//
//  User.swift
//  tasker
//
//  Created by Kevin Babou on 2/23/22.
//

import Foundation

struct User {
    var firstname: String?
    var lastname: String?
    var gender: String?
    var address: address?
    var email: String?
    var password: String?  //TODO: Note. Passwords are string for temporary purposes only
                           //In production application, with actual users, never
                           //save password as unhashed, unencrypted strings!!!!
    var employee: Bool?
    var rating: Int?
    var employeeDescription: String?
    var uid: String?
    var dateOfBirth: String?
}

extension User {
    struct address {
        var city: String?
        var country: String?
        var phone: String?
        var state: String?
        var streetAddress: String?
        var zipCode: String?
    }
}
