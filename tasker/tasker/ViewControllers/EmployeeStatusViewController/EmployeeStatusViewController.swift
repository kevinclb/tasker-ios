//
//  EmployeeStatusViewController.swift
//  tasker
//
//  Created by User on 4/7/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class EmployeeStatusViewController: UIViewController {
    
    @IBOutlet weak var employeeStatus: UILabel!
    @IBOutlet weak var errorMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let db = Firestore.firestore()
        guard let userID = Auth.auth().currentUser?.uid else {return}
        db.collection("users").document(userID).getDocument  { snapshot, error in
            if error != nil {
                print("error fetching user document")
            } else {
                let employOrNot = snapshot?.get("employee") as! Bool
                if(employOrNot != false){
                    self.employeeStatus.text = "Active"
                }
            }
        }

    }

    @IBAction func signUpTapped(_ sender: Any) {
        let db = Firestore.firestore()
        guard let userID = Auth.auth().currentUser?.uid else {return}
        db.collection("users").document(userID).getDocument  { snapshot, error in
            if error != nil {
                print("error fetching user document")
            } else {
                let employOrNot = snapshot?.get("employee") as! Bool
                if(employOrNot == false){
                    db.collection("users").document(userID).updateData(["employee":true])
                    self.errorMessage.text = "You have successfully signed up for an employee account."
                    self.employeeStatus.text = "Active"
                }
                else{
                    self.errorMessage.text = "You are already signed up for an employee account!"
                }
            }
        }
        
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        // this code here is to present from right to left instead of bottom to top
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = .fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false, completion: nil)
    }
    
}
