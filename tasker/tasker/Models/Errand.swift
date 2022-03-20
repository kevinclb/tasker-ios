//
//  taskModel.swift
//  tasker
//
//  Created by Jeffrey Viramontes on 2/15/22.
//

import Foundation


import Foundation

// MARK: - Errand
class Errand: Codable {
    var title: String?
    var employeeID: String?
    var price: Int?
    var isCompleted: Bool?
    var negotiable: Bool?
    var category, taskDescription: String?
    var location: Address?
    private var errand: Errand?
    
    enum CodingKeys: String, CodingKey {
        case employeeID, price, isCompleted, location, negotiable, category
        case taskDescription = "description"
    }

    init(title: String?, employeeID: String?, price: Int?, isCompleted: Bool?, location: Address?, negotiable: Bool?, category: String?, taskDescription: String?) {
        self.title = title
        self.employeeID = employeeID
        self.price = price
        self.isCompleted = isCompleted
        self.negotiable = negotiable
        self.category = category
        self.taskDescription = taskDescription
        self.location = location
    }
}

extension Errand {
    func fetchWork(documentId: String) {
        let docRef = db.collection("tasks").document(documentId)
        
        docRef.getDocument { (document, error) in
            if let e = error {
                print("there was an error retrieving task data from firestore. \(e)")
            } else {
                if document?.data() == nil {
                    print("error with the document data")
                } else {
                    do {
                        print("document data: \(String(describing: document?.data()))")
                        self.errand = try document?.data(as: Errand.self)
                    }
                    catch {
                        print(error)
                    }
                }
            }
        }
    }
}
