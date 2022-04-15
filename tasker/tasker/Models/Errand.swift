//
//  taskModel.swift
//  tasker
//
//  Created by Jeffrey Viramontes on 2/15/22.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase

// MARK: - Errand
class Errand: Codable {
    
    @DocumentID var docid: String?
    var title, category, taskDescription: String
    var price: Double?
    var negotiable, isCompleted, hasPaid, employeeRated, clientRated: Bool?
    var location: Address?
    var listingDate: Date?
    var hireDate: Date?
    var employeeID: String?
    private var errand: Errand?
//
//    enum CodingKeys: String, CodingKey {
//        case employeeID, price, isCompleted, location, negotiable, category
//        case taskDescription = "description"
//    }
//
    init(title: String, category: String, taskDescription: String, employeeID: String, isCompleted: Bool?, hasPaid: Bool?, employeeRated: Bool?, clientRated: Bool?, location: Address, negotiable: Bool, price: Double) {
        self.title = title
        self.category = category
        self.taskDescription = taskDescription
        self.employeeID = employeeID
        self.isCompleted = isCompleted
        self.hasPaid = hasPaid
        self.employeeRated = employeeRated
        self.clientRated = clientRated
        self.price = price
        self.negotiable = negotiable
        self.location = location
    }
    
    
    init(title: String, category: String, taskDescription: String, employeeID: String, isCompleted: Bool?, hasPaid: Bool?, employeeRated: Bool?) {
        self.title = title
        self.category = category
        self.taskDescription = taskDescription
        self.employeeID = employeeID
        self.isCompleted = isCompleted
        self.hasPaid = hasPaid
        self.employeeRated = employeeRated
    }
}

extension Errand {
//    func fetchWork(documentId: String) {
//        let docRef = db.collection("tasks").document(documentId)
//
//        docRef.getDocument { (document, error) in
//            if let e = error {
//                print("there was an error retrieving task data from firestore. \(e)")
//            } else {
//                if document?.data() == nil {
//                    print("error with the document data")
//                } else {
//                    do {
//                        print("document data: \(String(describing: document?.data()))")
//                        self.errand = try document?.data(as: Errand.self)
//                    }
//                    catch {
//                        print(error)
//                    }
//                }
//            }
//        }
//    }
}
