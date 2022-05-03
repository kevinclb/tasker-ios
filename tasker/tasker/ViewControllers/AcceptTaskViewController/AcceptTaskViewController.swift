//
//  AcceptTaskViewController.swift
//  tasker
//
//  Created by Jeffrey Viramontes on 3/26/22.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class AcceptTaskViewController: UIViewController {
    let userID = Auth.auth().currentUser?.uid
    var dID = ""
    let backToEmpVC = EmployeeExplorePageViewController()
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbLocation: UILabel!
    @IBOutlet weak var lbBody: UILabel!
    @IBOutlet weak var lbRate: UILabel!
    @IBAction func acceptClicked(_ sender: Any) {
        print("You pressed on DocID = " + dID)
        db.collection("tasks").document(dID).updateData(["employeeID": userID!
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        navigateToListTaskVC(backToEmpVC, .fromRight)
    }
    @IBAction func cancelClicked(_ sender: Any) {
        navigateToListTaskVC(backToEmpVC, .fromRight)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func navigateToListTaskVC(_ newViewController: UIViewController, _ transitionFrom:CATransitionSubtype) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.reveal
        transition.subtype = transitionFrom
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)


        // this code here is to make the viewcontroller we're presenting and make it show full screen then present it
        let newVC = newViewController
        newVC.modalPresentationStyle = .fullScreen
        // the app will automatically know how to animate the presentation, it will use the transition we made above on its own so that's why we set animated to false
        self.present(newVC, animated: false, completion: nil)
    }
}
