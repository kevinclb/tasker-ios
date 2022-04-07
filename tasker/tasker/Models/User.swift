//
//  User.swift
//  tasker
//
//  Created by Kevin Babou on 2/23/22.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase

// MARK: - User
class User: Codable {
    
    @DocumentID var docid: String?
    private var user: User?
    var employee: Bool?
    var firstname, uid, email: String?
    var address: Address?
    var lastname: String?
    var rating: Double?
    var dateOfBirth: String?
    var employeeDescription, bio, profilePicLink, city, phone, gender: String?
    var skills: String?
    
    required init() {
    }
    
    init(employee: Bool?, firstname: String?, uid: String?, email: String?, address: Address?, lastname: String?, rating: Double?, dateOfBirth: String?, id: String?, employeeDescription: String?, bio: String?, city: String?, gender: String?, skills: String?, profilePicLink: String?, phone: String?) {
        self.employee = employee
        self.firstname = firstname
        self.uid = uid
        self.email = email
        self.address = address
        self.lastname = lastname
        self.rating = rating
        self.dateOfBirth = dateOfBirth
        self.employeeDescription = employeeDescription
        self.bio = bio
        self.city = city
        self.gender = gender
        self.skills = skills
        self.profilePicLink = profilePicLink
        self.phone = phone
    }
}



extension User {
    func fetchUser(documentId: String) async throws -> DocumentSnapshot {
        let docRef = db.collection("users").document(documentId)
        var snap: Firebase.DocumentSnapshot?
        do {
            print("trying to get document snapshot")
            let snapshot = try await docRef.getDocument()
            if !snapshot.exists {
                print("snapshot does not exist")
            }
            snap = snapshot
            do {
                print("trying to decode snapshot data as user object")
                user = try snapshot.data(as: User.self)
            } catch {
                print("error decoding user document data")
            }
        } catch {
            print("failed to fetch user document.")
        }
        print("snapshot type: ", type(of: snap))
        return snap!
    }
    
    func fetchQuerySnapshotArray(userCollectionRef: CollectionReference) -> [QueryDocumentSnapshot]? {
        var documentSnapshots: [QueryDocumentSnapshot]?
        userCollectionRef.getDocuments { (snapshot, error) in
            if let err = error {
                debugPrint("Error fetching docs: \(err)")
            } else {
                documentSnapshots = snapshot?.documents
                print(documentSnapshots)
                print("printed from user class")
            }
        }
        return documentSnapshots
    }
    
}
