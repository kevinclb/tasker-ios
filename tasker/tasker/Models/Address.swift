//
//  Address.swift
//  tasker
//
//  Created by Kevin Babou on 3/20/22.
//

import Foundation


// MARK: - Address
struct Address: Codable {
    var phone, streetAddress: String?
    var city, state, country: String?
    var zipcode: Int?
    
    init(phone: String, streetAddress: String, city: String, state: String, zipcode: Int, country: String) {
        self.phone = phone
        self.streetAddress = streetAddress
        self.zipcode = zipcode
        self.country = country
        self.state = state
        self.city = city
    }
    init() {
        self.phone = nil
        self.streetAddress = nil
        self.zipcode = nil
        self.city = nil
        self.country = nil
        self.state = nil
    }
}
