//
//  NotificationSettingsViewController.swift
//  tasker
//
//  Created by User on 5/2/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class NotificationSettingsViewController: UIViewController {
    @IBOutlet weak var toggle: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let db = Firestore.firestore()
        guard let userID = Auth.auth().currentUser?.uid else {return}
        let docRef = db.collection("users").document(userID)

        // check the notification variable for the user in the database so we know how to initialize the toggle, in the on or off position
        docRef.getDocument(source: .cache) { (document, error) in
            if let document = document {
                let data = document.data()
                let property = data!["notifications"]! as? Bool ?? true
                self.toggle.setOn(property, animated: false)
            } else {
                print("Document does not exist in cache")
            }
        }
        
    }

    @IBAction func switchToggled(_ sender: Any) {
        var turnedon:Bool
        guard let userID = Auth.auth().currentUser?.uid else {return}
        if(toggle.isOn){
            turnedon = true
        }else{
            turnedon = false
        }
        let db = Firestore.firestore()
        
        db.collection("users").document(userID).updateData(["notifications":turnedon])
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
