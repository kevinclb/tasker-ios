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
    var userID: String = ""
    var numOfRatings: Int = 0
    var currentRating: Double = 0
    var givenRating: Double = 0
    var newUserRating: Double = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Retrieve the user's number of ratings and current rating
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(userID)
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
    
    func setUserID(userID: String) {
        self.userID = userID
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
        givenRating = Double((category1Rating + category2Rating + category3Rating) / numOfCategories)
        
        // Calculating the users new rating that will be updated on the database.
        newUserRating = ((currentRating * Double(numOfRatings)) + givenRating) / (Double(numOfRatings) + 1)
        
        // Update values to database
        let db = Firestore.firestore()
        db.collection("users").document(userID).setData(["num_ratings": (numOfRatings + 1), "rating": newUserRating], merge: true)
        
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
