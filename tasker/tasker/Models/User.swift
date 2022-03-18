//
//  User.swift
//  tasker
//
//  Created by Kevin Babou on 2/23/22.
//

import Foundation

// MARK: - User
class User: Codable {
    let employee: Bool
    let firstname, uid, email: String
    let address: Address
    let lastname: String
    let rating: Double
    let dateOfBirth: String
    let id: Int
    let employeeDescription, ipAddress, city, gender: String

    init(employee: Bool, firstname: String, uid: String, email: String, address: Address, lastname: String, rating: Double, dateOfBirth: String, id: Int, employeeDescription: String, ipAddress: String, city: String, gender: String) {
        self.employee = employee
        self.firstname = firstname
        self.uid = uid
        self.email = email
        self.address = address
        self.lastname = lastname
        self.rating = rating
        self.dateOfBirth = dateOfBirth
        self.id = id
        self.employeeDescription = employeeDescription
        self.ipAddress = ipAddress
        self.city = city
        self.gender = gender
    }
}

// MARK: - Address
class Address: Codable {
    let phone, streetAddress: String
    let zipcode: Int
    let country, state, city: String

    init(phone: String, streetAddress: String, zipcode: Int, country: String, state: String, city: String) {
        self.phone = phone
        self.streetAddress = streetAddress
        self.zipcode = zipcode
        self.country = country
        self.state = state
        self.city = city
    }
}
