//
//  AccountSettingsViewController.swift
//  tasker
//
//  Created by User on 4/19/22.
//

import UIKit
import FirebaseAuth

class AccountSettingsViewController: UIViewController {
    
    @IBOutlet weak var curPass: UITextField!
    @IBOutlet weak var newPass: UITextField!
    @IBOutlet weak var confirmPass: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    @IBAction func confirmTapped(_ sender: Any) {
        let cur:String = curPass.text ?? ""
        let new:String = newPass.text ?? ""
        let er = validateFields()
                
        if(er != nil){
            Utilities.showError(message: er!, errorLabel: errorMessage)
        }
        else{
            // in order to allow user to change their password they need to know their old one and be able to sign in with it, that's how we test the old password was entered correctly
            let user = Auth.auth().currentUser
            let credentials = EmailAuthProvider.credential(withEmail: (user?.email)!, password: cur)
            user?.reauthenticate(with: credentials){ result, error in
                if let error = error{
                    Utilities.showError(message: error.localizedDescription, errorLabel: self.errorMessage)
                }else{
                    // This is where we update the password
                    Auth.auth().currentUser?.updatePassword(to: new) { (error) in
                        if(error != nil){
                            Utilities.showError(message: error!.localizedDescription, errorLabel: self.errorMessage)
                        }
                        else{
                            self.errorMessage.text = "Password updated successfully"
                            self.errorMessage.textColor = UIColor.green
                        }
                    }
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
    
    func validateFields() -> String? {
        
        // Checking if all fields are filled in.
        if curPass.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            newPass.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            confirmPass.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields."
        }
        
        // Checking if email and password are valid entries.
        let new = newPass.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let confirm = confirmPass.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        if Utilities.isPasswordValid(password: new) == false {
            // Password they entered isn't secure
            
            return "Password must be 8 characters long\nwith numbers and a special character."
        }
        
        if new != confirm{
            // Confirmed password does not match the original password they inputted.
            
            return "You've entered passwords that do not match."
        }
        
        return nil
    }
    

}
