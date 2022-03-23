//
//  RegistrationStep2ViewController.swift
//  tasker
//
//  Created by Amir Hammoud on 2/10/22.
//

import UIKit
import FirebaseAuth
import Firebase
import GoogleSignIn


//TODO: Add better validation and data cleansing.

//TODO: Add error checking

class SetupPageViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var zipCodeTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var aptTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var bioTextField: UITextField!
    @IBOutlet weak var yourNameTextLabel: UILabel!
    
    @IBOutlet weak var avatarImage: UIImageView!
    
    var name = ["Your", "Name"]
    
    var isEmployee = false
    let registerStep1VC = RegistrationStep1ViewController()
    
    @IBOutlet weak var skillsTextField: UITextField!
    
    var firstName: String = ""
    var lastName: String = ""
    private var email: String = ""
    private var password: String = ""
    private var googleCredentials: AuthCredential?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    func setEmail(email: String) {
        self.email = email
    }
    
    func getEmail() -> String {
        return email
    }
    
    func setPassword(password: String) {
        self.password = password
    }
    
    func getPassword() -> String {
        return password
    }
    
    func setGoogleCredentials(credentials: AuthCredential)  {
        self.googleCredentials = credentials
    }

    func getGoogleCredentials() -> AuthCredential {
        return googleCredentials!
    }
    
    @IBAction func firstNameEditingEnded(_ sender: UITextField) {
        
        self.name[0] = self.firstNameTextField.text!
        self.yourNameTextLabel.text = self.name[0] + " " + self.name[1]
    }
    
    @IBAction func lastNameEditingEnded(_ sender: UITextField) {
        self.name[1] = self.lastNameTextField.text!
        self.yourNameTextLabel.text = self.name[0] + " " + self.name[1]
        
    }
    
    
    
    func validateFields() -> String? {
        
        // Checking if all fields are filled in.
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            dateOfBirthTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            zipCodeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all required fields."
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
            var street = streetTextField.text!
            if aptTextField.text != "" {
                street = street + aptTextField.text!
            }
            let city = cityTextField.text!
            let state = stateTextField.text!
            let bio = bioTextField.text!
            
            // Check to see if this is a standard registration or Google registration
            if password != "" {
                // Regular Registration
                Auth.auth().createUser(withEmail: getEmail(), password: getPassword()) { (result, err) in
                    
                    // Check for errors
                    if err != nil{
                        let errMessage = "Error creating user: " + err!.localizedDescription
                        Utilities.showError(message: errMessage, errorLabel: self.errorLabel)
                        
                        }
                    else {
                        // User was created successfully, now store the data
                        let userID = result!.user.uid
                        self.setUserData(userID: userID, firstName: firstName, lastName: lastName, dateOfBirth: dateOfBirth, city: city, street: street, zipCode: zipCode!, bio: bio, state: state)
                                // Direct to home view
                                self.segueToHomeVC()
                            }
                    
                }
            }
                else{
                    // Google Registration
                    Auth.auth().signIn(with: self.googleCredentials!) { result, err in
                    
                    // Check for errors
                    if let err = err {
                        Utilities.showError(message: err.localizedDescription, errorLabel: self.errorLabel)
                    }
                        
                else {
                    // User was created successfully, now store the data
                    let userID = result!.user.uid
                    self.setUserData(userID: userID, firstName: firstName, lastName: lastName, dateOfBirth: dateOfBirth, city: city, street: street, zipCode: zipCode!, bio: bio, state: state)
                            // Direct to home view
                            self.segueToHomeVC()
                        
                    
                }
                        
                    }
                    
                }
            
        }
        
    }
    
    //TODO: Try to implement this function to clean up some code
    func setUserData(userID: String, firstName: String, lastName: String, dateOfBirth: String, city: String, street: String, zipCode: Int, bio: String, state: String) {
        let db = Firestore.firestore()
        
        db.collection("users").document(userID).setData(
            ["firstname": firstName,
             "lastname": lastName,
             "dateOfBirth": dateOfBirth,
             "address": [
                "city": city,
                "country": "US",
                "phone": "",
                "streetAddress": street,
                "state": state,
                "zipcode": zipCode
                
             ],
             "rating": 0,
             "bio": bio,
             "employeeDescription": "",
             "skills": self.skillsTextField.text ?? "",
             "employee": self.isEmployee,
             "uid": userID,
             "email": self.getEmail(),
             "gender": "",
             "num_ratings": 0,
            ]) { (error) in
                
                if error != nil {
                    // Show error message
                    Utilities.showError(message: "Error saving user data.", errorLabel: self.errorLabel)
                    
                }
            }
    }
    
    func segueToHomeVC() {
        // Segue to home explore page and programatically change root view controller to home explore page
        
        let homePageVC = HomeExplorePageViewController()

        homePageVC.modalPresentationStyle = .fullScreen
        self.present(homePageVC, animated: true, completion: nil)
    }
     
}

extension SetupPageViewController {
    @IBAction func checkBoxPressed(_ sender: CheckBox) {
        print("checkBoxPressed")
        self.isEmployee = !self.isEmployee
    }
}
