//
//  taskModel.swift
//  tasker
//
//  Created by Jeffrey Viramontes on 2/15/22.
//

import Foundation


import Foundation

// MARK: - Task
class Task: Codable {
    var employeeID: String?
    var price: Int?
    var isCompleted: Bool?
    var location: String?
    var negotiable: Bool?
    var category, taskDescription: String?
    private var task: Task?
    
    enum CodingKeys: String, CodingKey {
        case employeeID, price, isCompleted, location, negotiable, category
        case taskDescription = "description"
    }

    init(employeeID: String?, price: Int?, isCompleted: Bool?, location: String?, negotiable: Bool?, category: String, taskDescription: String?) {
        self.employeeID = employeeID
        self.price = price
        self.isCompleted = isCompleted
        self.location = location
        self.negotiable = negotiable
        self.category = category
        self.taskDescription = taskDescription
    }
}

extension Task {
    func fetchTask(documentId: String) {
        let docRef = db.collection("tasks").document(documentId)
        
        docRef.getDocument { (document, error) in
            if let e = error {
                print("there was an error retrieving task data from firestore. \(e)")
            } else {
                if document?.data() == nil {
                    print("error with the document data")
                } else {
                    do {
                    print("document data: \(document?.data())")
                    self.task = try document?.data(as: Task.self)
                    }
                    catch {
                        print(error)
                    }
                }
            }
        }
    }
}
