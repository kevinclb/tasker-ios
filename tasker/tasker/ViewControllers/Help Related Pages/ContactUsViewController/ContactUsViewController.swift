//
//  ContactUsViewController.swift
//  tasker
//
//  Created by User on 3/16/22.
//

import UIKit
import MessageUI
import FirebaseAuth
import Firebase
import FirebaseFirestore

class ContactUsViewController: UIViewController, MFMailComposeViewControllerDelegate {
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var subject: UITextField!
    @IBOutlet weak var message: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        self.resignFirstResponder()
    }
    
    @IBAction func send(_ sender: Any) {
        let toRecipients = ["taskersup@gmail.com"]
        let userID : String = (Auth.auth().currentUser?.uid)!
        var name : String = ""
        db.collection("users").document(userID).getDocument { (snapshot, error) in
                    if error != nil {
                        print(error ?? "An error occured")
                    } else {
                        if let doc = snapshot {
                            if let tempN = doc.get("firstName") as? String {
                                name += tempN
                            }
                            if let tempL = doc.get("lastName") as? String {
                                name += tempL
                            }
                            else {
                                print("error getting field")
                                name = "Unknown"
                            }
                        }
                    }
        }
        let mc:MFMailComposeViewController = MFMailComposeViewController()
        mc.mailComposeDelegate = self
        mc.setToRecipients(toRecipients)
        mc.setSubject(subject.text!)
        mc.setMessageBody("User Id: \(userID)\n\nName: \(name)\n\nEmail: \(email.text!)\n\nMessage: \(message.text!)", isHTML: false)
        self.present(mc, animated: true, completion: nil)
    }
    
    // Dismisses the mail stuff after user sends, cancels, or saves email
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
