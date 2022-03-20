//
//  RegistrationStep2ViewController.swift
//  tasker
//
//  Created by Amir Hammoud on 2/10/22.
//

import UIKit
import FirebaseAuth
import Firebase

//TODO: Add more fields onto RegistrationStep2 and finish the backend logic for it.

class SetupPageViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var zipCodeTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    
    let registerStep1VC = RegistrationStep1ViewController()
    
    var email: String = ""
    var password: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setEmail(email: String){
        self.email = email
    }
    
    func setPassword(password: String){
        self.password = password
    }
    
    func validateFields() -> String? {
        
        // Checking if all fields are filled in.
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            dateOfBirthTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            zipCodeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields."
        }
        
        // TODO: Checking if their date of birth is valid
        
        let cleanedDateOfBirth = dateOfBirthTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedZipCode = zipCodeTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isAgeValid(date: cleanedDateOfBirth) == false {
            // Age they entered was not valid
            
            return "Please enter a valid date of birth\n(must be 18 years or older)."
        }
        
        if Utilities.isZipCodeValid(zipCode: cleanedZipCode) == false {
            // Zip code they entered was not valid
            
            return "The zip code you entered was not valid\n(must be 5 digits)."
        }
        
        return nil
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        self.resignFirstResponder()
    }
    
    
    @IBAction func continuePressed(_ sender: Any) {
        
        // Validate fields
        let error = validateFields()
        if error != nil {
            // There was something wrong with the fields, show error message
            Utilities.showError(message: error!, errorLabel: self.errorLabel)
        }
        else {
            // Create cleaned versions of data
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let dateOfBirth = dateOfBirthTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let zipCode = Int(zipCodeTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines))
            
            // Create User
            Auth.auth().createUser(withEmail: self.email, password: self.password) { (result, err) in
                
                // Check for errors
                if err != nil{
                    let errMessage = "Error creating user: " + err!.localizedDescription
                    Utilities.showError(message: errMessage, errorLabel: self.errorLabel)
                }
                
                else {
                    // User was created successfully, now store the data
                    let db = Firestore.firestore()
                    let userID = result!.user.uid
                    db.collection("users").document(userID).setData(
                        ["firstname": firstName,
                         "lastname": lastName,
                         "dateOfBirth": dateOfBirth,
                         "address": [
                            "city": "",
                            "country": "",
                            "phone": "",
                            "streetAddress": "",
                            "state": "",
                            "zipcode": zipCode!
                            
                         ],
                         "rating": 0,
                         "employeeDescription": "",
                         "skills": [],
                         "employee": false,
                         "uid": userID,
                         "email": self.email,
                         "gender": "",
                         "num_ratings": 0,
                        ]) { (error) in
                            
                            if error != nil {
                                // Show error message
                                Utilities.showError(message: "Error saving user data.", errorLabel: self.errorLabel)
                            }
                            // Segue to home explore page and programatically change root view controller to home explore page
                            let homePageVC = HomeExplorePageViewController()
                            
                            self.view.window?.rootViewController = homePageVC
                            self.view.window?.makeKeyAndVisible()
                            
                            homePageVC.modalPresentationStyle = .fullScreen
                            self.present(homePageVC, animated: true, completion: nil)
                        }
                    
                    
                }
            }
        }
    }
}
