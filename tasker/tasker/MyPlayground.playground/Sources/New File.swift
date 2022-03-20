import Foundation
import FirebaseFirestore
//import FirebaseFirestoreSwift
//



let db = Firestore.firestore()

public class Errand: Codable {
    
    public var title, category, taskDescription, employeeID: String
    public var price: Int?
    public var negotiable, isCompleted: Bool?
    public var location: Address?
    public var date: Date?
    public var errand: Errand?
    
    //    public init() {
    //        self.title = "Washing the Dishes"
    //        self.category = "cleaning"
    //        self.taskDescription = "I'm going to be out of town on a work trip and I need someone to wash my dishes for me."
    //        self.employeeID = "1"
    //        self.isCompleted = false
    //        self.location = Address(phone: "703-223-8591", streetAddress: "237 State St", zipcode: 90210, country: "US", state: "CA", city: "Beverly Hills")
    //        self.negotiable = false
    //        self.price = 25
    //        self.date = Date.now
    //    }
    
    init(title: String, category: String, taskDescription: String, employeeID: String, isCompleted: Bool?, location: Address, negotiable: Bool, price: Int, date: Date) {
        self.title = title
        self.category = category
        self.taskDescription = taskDescription
        self.employeeID = employeeID
        self.isCompleted = isCompleted
        self.price = price
        self.negotiable = negotiable
        self.location = location
        self.date = date
    }
    
    init(title: String, category: String, taskDescription: String, employeeID: String, isCompleted: Bool?) {
        self.title = title
        self.category = category
        self.taskDescription = taskDescription
        self.employeeID = employeeID
        self.isCompleted = isCompleted
    }
    
    public func NewErrand() -> Errand {
        return Errand(title: "Washing the Dishes",
                      category: "cleaning",
                      taskDescription: "I'm going to be out of town on a work trip and I need someone to wash my dishes for me.",
                      employeeID: "1",
                      isCompleted: false,
                      location: Address(phone: "703-223-8591", streetAddress: "237 State St", zipcode: 90210, country: "US", state: "CA", city: "Beverly Hills"),
                      negotiable: false,
                      price: 25,
                      date: Date.now)
    }
}

public class User: Codable {
    
    private var user: User?
    var employee: Bool?
    var firstname, uid, email: String?
    var address: Address?
    var lastname: String?
    var rating: Double?
    var dateOfBirth: String?
    var employeeDescription, ipAddress, city, gender: String?
    var skills: [String]?
    
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

public struct Address: Codable {
    public var phone, streetAddress: String?
    public var zipcode: Int?
    public var country, state, city: String?
    
    public init(phone: String, streetAddress: String, zipcode: Int, country: String, state: String, city: String) {
        self.phone = phone
        self.streetAddress = streetAddress
        self.zipcode = zipcode
        self.city = city
        self.country = country
        self.state = state
    }
    
    public init() {
        self.phone = nil
        self.streetAddress = nil
        self.zipcode = nil
        self.city = nil
        self.country = nil
        self.state = nil
    }
}

public class Car {
    var color: String
    var size: String
    var drive: Bool
    
    public init(color: String, size: String, drive: Bool) {
        self.color = color
        self.size = size
        self.drive = drive
    }
}

public func getTaskCollection() {
    var errand: Errand!
    let collRef = db.collection("tasks")
    collRef.getDocuments { snapshot, error in
        if let error = error {
            print("error: \(error.localizedDescription)")
        } else {
            print("loading snapshot successful")
            guard let snapshot = snapshot else { return }
            for document in snapshot.documents {
                do {
                    errand = try document.data(as: Errand.self)
                } catch {
                    print("error decoding taskers to HomePageVC taskers array")
                }
                print("nested returning errand:", errand!)
            }
            print("returning Errand: ", errand!)
        }
    }
}

