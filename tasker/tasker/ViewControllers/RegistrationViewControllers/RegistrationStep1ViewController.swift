//
//  RegistrationStep1ViewController.swift
//  tasker
//
//  Created by Amir Hammoud on 2/14/22.
//

import UIKit

class RegistrationStep1ViewController: UIViewController {
    
    @IBOutlet weak var emailAddressLabel: UILabel!
    
    @IBOutlet weak var emailAddressTextField: UITextField!
    
    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordLabel: UILabel!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var continueButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var registerWithGoogleButton: UIButton!
    
    @IBOutlet weak var registerWithAppleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func validateFields() -> String? {
        
        // Checking if all fields are filled in.
        if emailAddressTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            confirmPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields"
        }
        
        // Checking if email and password are valid entries.
        let cleanedEmail = emailAddressTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedConfirmedPassword = confirmPasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isEmailValid(email: cleanedEmail) == false {
            // Email they entered wasn't valid
            
            return "Please enter a valid email address"
        }
        
        if Utilities.isPasswordValid(password: cleanedPassword) == false {
            // Password they entered isn't secure
            
            return "Password must be 8 characters long\nwith numbers and a special character"
        }
        
        if cleanedConfirmedPassword != cleanedPassword{
            // Confirmed password does not match the original password they inputted.
            
            return "You've entered passwords that do not match"
        }
        
        return nil
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func continueTapped(_ sender: Any) {
        
        let error = validateFields()
        
        if error != nil {
            // There was something wrong with the fields, show error message
            Utilities.showError(message: error!, errorLabel: self.errorLabel)
        }
        else {
            let registerPage2VC = RegistrationStep2ViewController()
            self.present(registerPage2VC, animated: true, completion: nil)
        }
    }
}
