//
//  User.swift
//  tasker
//
//  Created by Kevin Babou on 2/23/22.
//

import Foundation
import FirebaseFirestoreSwift

// MARK: - User
class User: Codable {
    
    @DocumentID var id: String?
    var employee: Bool?
    var firstname, uid, email: String?
    var address: Address?
    var lastname: String?
    var rating: Double?
    var dateOfBirth: String?
    var employeeDescription, ipAddress, city, gender: String?
    var skills: [String]?
    private var user: User?
    
    required init() {
    }
    
    init(employee: Bool?, firstname: String?, uid: String?, email: String?, address: Address?, lastname: String?, rating: Double?, dateOfBirth: String?, id: String?, employeeDescription: String?, ipAddress: String?, city: String?, gender: String?, skills: [String]?) {
        self.employee = employee
        self.firstname = firstname
        self.uid = uid
        self.email = email
        self.address = address
        self.lastname = lastname
        self.rating = rating
        self.dateOfBirth = dateOfBirth
        self.employeeDescription = employeeDescription
        self.ipAddress = ipAddress
        self.city = city
        self.gender = gender
        self.skills = skills
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

extension User {
    func fetchUser(documentId: String) {
        let docRef = db.collection("users").document(documentId)
        
        docRef.getDocument { (document, error) in
            if let e = error {
                print("there was an error retrieving data from firestore. \(e)")
            } else {
                if document?.data() == nil {
                    print("error with the document data")
                } else {
                    do {
                    print("document data: \(document?.data())")
                    self.user = try document?.data(as: User.self)
                    }
                    catch {
                        print(error)
                    }
                }
            }
        }
    }
    
}
