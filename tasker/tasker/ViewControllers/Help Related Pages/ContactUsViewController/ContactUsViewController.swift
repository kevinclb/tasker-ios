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
    @IBOutlet weak var errorLabel: UILabel!
    
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
        let messageBody = message.text!
        let emailField = email.text!
        let subjectField = subject.text!
        // Check the fields to ensure none were empty
        if(messageBody.isEmpty || emailField.isEmpty || subjectField.isEmpty){
            errorLabel.text = "One or more fields is empty, please make sure all fields are filled"
            return
        }
        Utilities.showError(message: "", errorLabel: errorLabel)
        // This is the support email for the developer team which the message will be sent to
        let toRecipients = ["taskersup@gmail.com"]
        let userID : String = (Auth.auth().currentUser?.uid)!
        var name : String = ""
        // Get information about the user to include it in the body of the email
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
        // This is the view controller which will be used from the mail app to send a message to development team, we initialize and populate it then present it
        let mc:MFMailComposeViewController = MFMailComposeViewController()
        mc.mailComposeDelegate = self
        mc.setToRecipients(toRecipients)
        mc.setSubject(subjectField)
        mc.setMessageBody("User Id: \(userID)\n\nName: \(name)\n\nEmail: \(emailField)\n\nMessage: \(messageBody)", isHTML: false)
        self.present(mc, animated: true, completion: nil)
    }
    
    // Dismisses the mail stuff after user sends, cancels, or saves email
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
