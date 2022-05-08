//
//  PaidMechanismViewController.swift
//  tasker
//
//  Created by Amir Hammoud on 4/15/22.
//

import UIKit
import Firebase

class PaidMechanismViewController: UIViewController {
    
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    private var docID: String = ""
    
    // Setter to set the docID.
    func setDocID(docID: String) {
        self.docID = docID
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // Function for when the confirmed button is tapped.
    @IBAction func confirmButtonTapped(_ sender: Any) {
        
        let db = Firestore.firestore()
        
        // Setting the "hasPaid" field in the database to true, indicating that the client has paid an employee in person.
        db.collection("tasks").document(docID).setData(["hasPaid": true], merge: true)
        
        // Animation code to transition back to the recent tasks page.
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = .fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        // this code here is to make the viewcontroller we're presenting and make it show full screen then present it
        let recentTasksVC = RecentTasksTableViewController()
        recentTasksVC.modalPresentationStyle = .fullScreen
        // the app will automatically know how to animate the presentation, it will use the transition we made above on its own so that's why we set animated to false.
        present(recentTasksVC, animated: false, completion: nil)
    }
    
    // Function to go back to the recent tasks page in case the user doesn't want to leave a rating yet.
    @IBAction func backButtonTapped(_ sender: Any) {
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = .fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false, completion: nil)
        
    }
}
