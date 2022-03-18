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
    let employeeID: String
    let price: Int
    let isCompleted: Bool
    let location: JSONNull?
    let negotiable: Bool
    let category, taskDescription: String

    enum CodingKeys: String, CodingKey {
        case employeeID, price, isCompleted, location, negotiable, category
        case taskDescription = "description"
    }

    init(employeeID: String, price: Int, isCompleted: Bool, location: JSONNull?, negotiable: Bool, category: String, taskDescription: String) {
        self.employeeID = employeeID
        self.price = price
        self.isCompleted = isCompleted
        self.location = location
        self.negotiable = negotiable
        self.category = category
        self.taskDescription = taskDescription
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
