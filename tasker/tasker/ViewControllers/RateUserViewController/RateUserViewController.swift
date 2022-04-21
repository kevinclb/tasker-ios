//
//  RateUserViewController.swift
//  tasker
//
//  Created by Amir Hammoud on 4/14/22.
//

import UIKit
import Firebase

class RateUserViewController: UIViewController {
    
    @IBOutlet weak var category1Label: UILabel!
    @IBOutlet var category1StarButtons: [UIButton]!
    
    @IBOutlet weak var category2Label: UILabel!
    @IBOutlet var category2StarButtons: [UIButton]!
    
    @IBOutlet weak var category3Label: UILabel!
    @IBOutlet var category3StarButtons: [UIButton]!
    
    @IBOutlet weak var completeButton: UIButton!
    
    @IBOutlet weak var backButton: UIButton!
    
    var category1Rating: Int = 0
    var category2Rating: Int = 0
    var category3Rating: Int  = 0
    let numOfCategories: Int = 3
    let maxRating: Int = 15
    var numOfRatings: Int = 0
    var currentRating: Double = 0
    var givenRating: Double = 0
    var newUserRating: Double = 0
    private var employeeID: String = ""
    private var clientID: String = ""
    private var docID: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(clientID != "") {
            retriveClientRatings(clientID: clientID)
        }
        else {
            retriveEmployeeRatings(employeeID: employeeID)
        }
    }
    
    func setEmployeeID(employeeID: String) {
        self.employeeID = employeeID
    }
    
    func setClientID(clientID: String) {
        self.clientID = clientID
    }
    
    func setDocID(docID: String) {
        self.docID = docID
    }
    
    func retriveEmployeeRatings(employeeID: String) {
        
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(employeeID)
        docRef.getDocument { snapshot, error in
                    if error != nil {
                        print("error fetching user document")
                    } else {
                        do {
                            guard let user = try snapshot!.data(as: User.self) else{return}
                                
                            // ----- Set num of ratings
                            self.numOfRatings = user.num_ratings!
                            
                            // ----- Set current ratings
                            self.currentRating = user.rating!
                        } catch {
                            print("error: \(error.localizedDescription)")
                        }
            }
        }
    }
    
    func retriveClientRatings(clientID: String) {
        
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(clientID)
        docRef.getDocument { snapshot, error in
                    if error != nil {
                        print("error fetching user document")
                    } else {
                        do {
                            guard let user = try snapshot!.data(as: User.self) else{return}
                                
                            // ----- Set num of ratings
                            self.numOfRatings = user.num_ratings!
                            
                            // ----- Set current ratings
                            self.currentRating = user.rating!
                        } catch {
                            print("error: \(error.localizedDescription)")
                        }
            }
        }
    }
    
    @IBAction func category1StarButtonTapped(_ sender: UIButton) {
        
        let tag = sender.tag
        
        for button in category1StarButtons {
            if button.tag <= tag {
                // Show as selected
                button.setTitle("★", for: .normal)
                category1Rating = Int(tag) + 1
            }
            else {
                button.setTitle("☆", for: .normal)
            }
        }
    }
    
    @IBAction func category2StarButtonTapped(_ sender: UIButton) {
        
        let tag = sender.tag
        
        for button in category2StarButtons {
            if button.tag <= tag {
                // Show as selected
                button.setTitle("★", for: .normal)
                category2Rating = Int(tag) + 1
            }
            else {
                button.setTitle("☆", for: .normal)
            }
        }
    }
    
    @IBAction func category3StarButtonTapped(_ sender: UIButton) {
        
        let tag = sender.tag
        
        for button in category3StarButtons {
            if button.tag <= tag {
                // Show as selected
                button.setTitle("★", for: .normal)
                category3Rating = Int(tag) + 1
            }
            else {
                button.setTitle("☆", for: .normal)
            }
        }
    }
    
    @IBAction func completeButtonTapped(_ sender: Any) {
        
        // Calculating the overall rating based on the stars pressed.
        givenRating = Double((category1Rating + category2Rating + category3Rating)) / Double(numOfCategories)
        
        // Calculating the users new rating that will be updated on the database.
        newUserRating = ((currentRating * Double(numOfRatings)) + givenRating) / (Double(numOfRatings) + 1)
        
        let roundedRating = round(newUserRating * 100) / 100.0

        
        // Update values to database
        let db = Firestore.firestore()
        if(clientID != ""){
            db.collection("users").document(clientID).setData(["num_ratings": (numOfRatings + 1), "rating": roundedRating], merge: true)
            db.collection("tasks").document(docID).setData(["clientRated": true], merge: true)
        }
        else {
            db.collection("users").document(employeeID).setData(["num_ratings": (numOfRatings + 1), "rating": roundedRating], merge: true)
            db.collection("tasks").document(docID).setData(["employeeRated": true], merge: true)
        }
        
        // Transition back to recent tasks view
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = .fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        // this code here is to make the viewcontroller we're presenting and make it show full screen then present it
        let recentTasksVC = RecentTasksTableViewController()
        recentTasksVC.modalPresentationStyle = .fullScreen
        // the app will automatically know how to animate the presentation, it will use the transition we made above on its own so that's why we set animated to false
        present(recentTasksVC, animated: false, completion: nil)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        
        // This code here is to present from right to left instead of bottom to top
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = .fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false, completion: nil)
    }
}
