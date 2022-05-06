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
import FirebaseFirestore

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
    
    var fromThirdParty: Bool!
    var givenName: String!
    var familyName: String!
    var imagePicker:UIImagePickerController!
    var picTemp = ""

    @IBOutlet weak var avatarImage: UIImageView!
    
    var name = ["Your", "Name"]
    
    var isEmployee = false
    let dateFormatter = DateFormatter()
    let registerStep1VC = RegistrationStep1ViewController()
    
    @IBOutlet weak var skillsTextField: UITextField!
    
    var firstName: String = ""
    var lastName: String = ""
    private var email: String = ""
    private var password: String = ""
    private var credentials: AuthCredential?
    
    
    convenience init() {
        self.init(fromThirdParty: false, givenName: "", familyName: "")
    }
    
    init(fromThirdParty: Bool?, givenName: String?, familyName: String?) {
        super.init(nibName: nil, bundle: nil)
        self.fromThirdParty = fromThirdParty ?? false
        self.givenName = givenName ?? ""
        self.familyName = familyName ?? ""
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if fromThirdParty {
            yourNameTextLabel.text = self.givenName + " " + self.familyName
        }
        
        // This is for the image stuff
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        avatarImage.layer.cornerRadius = avatarImage.bounds.height / 2
        avatarImage.clipsToBounds = true
    }
    
    // Setters & getters for data received from registration step 1.
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
    
    func setCredentials(credentials: AuthCredential)  {
        self.credentials = credentials
    }
    
    func getCredentials() -> AuthCredential {
        return credentials!
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
            cityTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            stateTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            skillsTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            zipCodeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all required fields."
        }
        
        let cleanedDateOfBirth = dateOfBirthTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedZipCode = zipCodeTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isAgeValid(date: cleanedDateOfBirth) == false {
            // Age they entered was not valid
            
            return "Please enter a valid date of birth\n(must be 18 years or older)."
        }
        
        if Utilities.isZipCodeValid(zipCode: cleanedZipCode) == false {
            // Zip code they entered was not valid
            
            return "The zip code you entered was not valid\n(must be a 5 digit U.S. zip code)."

        }
        
        return nil
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        self.resignFirstResponder()
    }
    
    // Function for when the continue button is pressed.
    @IBAction func continuePressed(_ sender: Any) {
        
        // Validate fields
        let error = validateFields()
        if error != nil {
            // There was something wrong with the fields, show error message
            Utilities.showError(message: error!, errorLabel: self.errorLabel)
        }
        else {
            dateFormatter.dateFormat = "MM/dd/yyyy"
                        
            // Create cleaned versions of data
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                        
            let dateConversion = dateFormatter.date(from: dateOfBirthTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines))
            let dateOfBirth = dateFormatter.string(from: dateConversion!)
                        
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
                
                // Standard registration.
                Auth.auth().createUser(withEmail: getEmail(), password: getPassword()) { (result, err) in
                    
                    // Checking for errors.
                    if err != nil{
                        let errMessage = "Error creating user: " + err!.localizedDescription
                        Utilities.showError(message: errMessage, errorLabel: self.errorLabel)
                        
                    }
                    else {
                        // User was created successfully, now store the data.
                        let userID = result!.user.uid
                        guard let image = self.avatarImage.image else {return}
                        if(!image.isSymbolImage){
                            guard let image = self.avatarImage.image else {return}
                            guard let imageData = image.jpegData(compressionQuality: 0.75)else {return}
                            
                            let storageRef = Storage.storage().reference(forURL: "gs://developmentenvironment-224c8.appspot.com")
                            
                            let storageRefer = storageRef.child("UserPictures")
                            
                            let metaData = StorageMetadata()
                            metaData.contentType = "image/jpg"
                            
                            storageRefer.child(userID).putData(imageData, metadata: metaData) { metaData, error in
                                // first we check if the error is nil
                                if let error = error {
                                    return
                                }
                                // then we check if the metadata and path exists
                                // if the error was nil, we expect the metadata and path to exist
                                // therefore if not, we return an error
                                guard let metadata = metaData, let _ = metadata.path else {
                                    return
                                }
                                self.picTemp = userID
                                self.setUserData(userID: userID, firstName: firstName, lastName: lastName, dateOfBirth: dateOfBirth, city: city, street: street, zipCode: zipCode!, bio: bio, state: state)
                            }
                        }
                        else{
                            self.setUserData(userID: userID, firstName: firstName, lastName: lastName, dateOfBirth: dateOfBirth, city: city, street: street, zipCode: zipCode!, bio: bio, state: state)
                        }
                    }
                    
                }
            }
            else{
                // Registering with third party (Google or Facebook).
                Auth.auth().signIn(with: self.credentials!) { result, err in
                    
                    // Check for errors
                    if let err = err {
                        Utilities.showError(message: err.localizedDescription, errorLabel: self.errorLabel)
                    }
                    
                    else {
                        
                        // User was created successfully, now store the data
                        let userID = result!.user.uid
                        guard let image = self.avatarImage.image else {return}
                        if(!image.isSymbolImage){
                            guard let image = self.avatarImage.image else {return}
                            guard let imageData = image.jpegData(compressionQuality: 0.75)else {return}
                            
                            let storageRef = Storage.storage().reference(forURL: "gs://developmentenvironment-224c8.appspot.com")
                            
                            let storageRefer = storageRef.child("UserPictures")
                            
                            let metaData = StorageMetadata()
                            metaData.contentType = "image/jpg"
                            
                            storageRefer.child(userID).putData(imageData, metadata: metaData) { metaData, error in
                                // first we check if the error is nil
                                if let error = error {
                                    return
                                }
                                // then we check if the metadata and path exists
                                // if the error was nil, we expect the metadata and path to exist
                                // therefore if not, we return an error
                                guard let metadata = metaData, let _ = metadata.path else {
                                    return
                                }
                                self.picTemp = userID
                                self.setUserData(userID: userID, firstName: firstName, lastName: lastName, dateOfBirth: dateOfBirth, city: city, street: street, zipCode: zipCode!, bio: bio, state: state)
                            }
                        }
                        else{
                            self.setUserData(userID: userID, firstName: firstName, lastName: lastName, dateOfBirth: dateOfBirth, city: city, street: street, zipCode: zipCode!, bio: bio, state: state)
                        }
                        
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
                "streetAddress": street,
                "state": state,
                "zipcode": zipCode
                
             ],
             "phone": "",
             "rating": 0,
             "bio": bio,
             "employeeDescription": "",
             "skills": self.skillsTextField.text ?? "",
             "employee": self.isEmployee,
             "uid": userID,
             "email": self.getEmail(),
             "gender": "",
             "profilePicLink":picTemp,
             "num_ratings": 0,
             "notifications":true
            ]) { (error) in
                
                if error != nil {
                    // Show error message
                    Utilities.showError(message: "Error saving user data.", errorLabel: self.errorLabel)
                    
                }
            }
        // Direct to home view
        self.segueToHomeVC()
        
        
    }

    
    @IBAction func picButtonPressed(_ sender: Any) {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    func segueToHomeVC() {
        // Segue to home explore page and programatically change root view controller to home explore page
        
        let homePageVC = RootViewController()
        
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

extension SetupPageViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            self.avatarImage.image = pickedImage
        }
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
}
