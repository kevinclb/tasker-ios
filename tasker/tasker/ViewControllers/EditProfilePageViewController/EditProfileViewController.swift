//
//  EditProfileViewController.swift
//  tasker
//
//  Created by Kevin Babou on 2/2/22.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import FirebaseFirestoreSwift
import Foundation

class EditProfileViewController: UIViewController {
    // var for picking an image from photo library
    var imagePicker:UIImagePickerController!
    
    // boolean to check if user clicked on edit, initially false
    var editPressed:Bool = false;
    @IBOutlet weak var editOrSaveButton: UIButton!
    
    @IBOutlet weak var backButton: UIButton!
    
    // outlets for components to populate
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var dob: UITextField!
    @IBOutlet weak var bioTextfield: UITextView!
    @IBOutlet weak var street: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var zipCode: UITextField!
    @IBOutlet weak var country: UITextField!
    @IBOutlet weak var skills: UITextView!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var phoneNumber: UITextField!
    
    var linkToImg = ""

    // Edit bio and skills buttons
    @IBOutlet weak var editBioButton: UIButton!
    var bioExists:Bool = false
    @IBOutlet weak var editSkillsButton: UIButton!
    var skillsExists:Bool = false

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // This viewcontroller will act as a view profile info and edit as well, so first user will just view things, then if they click save then fields will become editable
        bioTextfield.isEditable = false
        skills.isEditable = false
        firstName.isUserInteractionEnabled = false
        lastName.isUserInteractionEnabled = false
        dob.isUserInteractionEnabled = false
        street.isUserInteractionEnabled = false
        city.isUserInteractionEnabled = false
        state.isUserInteractionEnabled = false
        zipCode.isUserInteractionEnabled = false
        country.isUserInteractionEnabled = false
        phoneNumber.isUserInteractionEnabled = false
        editPressed = false
        
        
        editBioButton.isUserInteractionEnabled = false
        editSkillsButton.isUserInteractionEnabled = false
        
        // This is for the image stuff
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        profilePic.layer.cornerRadius = profilePic.bounds.height / 2
        profilePic.clipsToBounds = true
        
        // When the view loads, lets go to the database and get info to populate fields so user can edit them
        activityIndicator.startAnimating()
        let db = Firestore.firestore()
        let storageRef = FirebaseStorage.Storage.storage().reference(forURL: "gs://developmentenvironment-224c8.appspot.com")
        guard let userID = Auth.auth().currentUser?.uid else {return}
        let docRef = db.collection("users").document(userID)
        docRef.getDocument { snapshot, error in
                    if error != nil {
                        self.activityIndicator.stopAnimating()
                        print("error fetching user document")
                    } else {
                        do {
                            guard let user = try snapshot!.data(as: User.self) else{return}
                                
                            // ----- Set first name
                            self.firstName.text = user.firstname
                            
                            // ----- Set last name
                            self.lastName.text = user.lastname
                            
                            // ----- Set dob
                            self.dob.text = user.dateOfBirth
                            
                            
                            // ----- Set phone number
                            self.phoneNumber.text = user.phone
                            
                            // ----- Set address
                            let str = user.address?.streetAddress
                            if(!str!.isEmpty){
                                self.street.text = str
                            }
                            let cit = user.address?.city
                            if(!cit!.isEmpty){
                                self.city.text = cit
                            }
                            let statee = user.address?.state
                            if(!statee!.isEmpty){
                                self.state.text = statee
                            }
                            let zip:Int = user.address?.zipcode ?? 0
                            self.zipCode.text = String(zip)
                            let ctr = user.address?.country
                            if(!ctr!.isEmpty){
                                self.country.text = ctr
                            }
                            
                            // ----- Set bio
                            let bio:String = user.bio ?? ""
                            if(!bio.isEmpty){
                                self.bioTextfield.text = bio
                                self.bioTextfield.textColor = UIColor.black
                                self.bioExists = true
                            }
                            else{
                                self.bioTextfield.text = "You currently do not have a bio, add one to tell people more about you!"
                                self.bioTextfield.textColor = UIColor.lightGray
                            }
                            
                            // ----- Set skills
                            let skill:String = user.skills ?? ""
                            if(!skill.isEmpty){
                                self.skills.text = skill
                                self.skills.textColor = UIColor.black
                                self.skillsExists = true
                            }
                            else{
                                self.skills.text = "You currently do not have any skills added, add some to tell people more about your skills!"
                                self.skills.textColor = UIColor.lightGray
                            }

                            
                            // ----- Set profile pic, check for existing, set if not empty
                            let profilepicURL:String = user.profilePicLink ?? ""
                            if(!profilepicURL.isEmpty){
                                storageRef.child("UserPictures").child(profilepicURL).getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
                                    let picture = UIImage(data: data!)
                                    self.profilePic.image = picture
                                    self.activityIndicator.stopAnimating()
                                }
                            }
                            else{
                                self.activityIndicator.stopAnimating()
                            }
                        } catch {
                            self.activityIndicator.stopAnimating()
                            print(error)
                    }
                }
        }
    }
   
    @IBAction func editImagePressed(_ sender: Any) {
        if(editPressed){
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func saveChangesTapped(_ sender: Any) {

        guard let userID = Auth.auth().currentUser?.uid else {return}
        
        // User has already chosen to edit info, so now they're clicking save, so save their changes
        if(editPressed){

            // Validate fields
            let error = validateFields()
            if error != nil {
                // There was something wrong with the fields, show error message
                errorMessage.text = error!
            }
            else{
                errorMessage.text = ""
                self.activityIndicator.startAnimating()

                // upload image to storage, get the url then put it into the map that will then update the user data
                guard let image = profilePic.image else {return}
                if(!image.isSymbolImage){
                    guard let imageData = image.jpegData(compressionQuality: 0.75)else {return}
                    let upldmgr = StorageManagager()
                    upldmgr.uploadData(imageData){url, error in
                        if let er = error {
                            self.errorMessage.textColor = .red
                            self.errorMessage.text = "Error in uploading picture, error code: "+er.localizedDescription.description
                        }
                        else{
                            self.errorMessage.text = ""
                        }
                    }
                    self.linkToImg = userID
                }
                
                
                // Create cleaned versions of data
                let fname = firstName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                let lname = lastName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                            
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy"
                let dateConversion = dateFormatter.date(from: dob.text!.trimmingCharacters(in: .whitespacesAndNewlines))
                let dateb = dateFormatter.string(from: dateConversion!)
                            
                let zip = Int(zipCode.text!.trimmingCharacters(in: .whitespacesAndNewlines))
                let streetNum = street.text!
                
                let cityName = city.text!
                let stateName = state.text!
                let countryName = country.text!
                var bioContent = bioTextfield.text!
                bioContent = bioContent.trimmingCharacters(in: .whitespacesAndNewlines)
                if(bioContent=="You currently do not have a bio, add one to tell people more about you!"){
                    bioContent = ""
                }
                var skillsContent = skills.text!
                skillsContent = skillsContent.trimmingCharacters(in: .whitespacesAndNewlines)
                if(skillsContent=="You currently do not have skills added, add one to tell people more about you!"){
                    skillsContent = ""
                }
                let number = phoneNumber.text!
                
                self.updateUserInfo(fname: fname, lname: lname, dateb: dateb, city: cityName, country: countryName, street: streetNum, state: stateName, zip: zip!, bio: bioContent, skills: skillsContent, phone:number, linkToImg: linkToImg)
            }
            editPressed = false
            let image = UIImage(named: "viewProfileEditProfile") as UIImage?
            editOrSaveButton.setImage(image, for: .normal)
        }
        // User just pressed the edit button to edit
        else{
            editPressed = true
            // Set the fields to editable
            bioTextfield.isEditable = true
            skills.isEditable = true
            firstName.isUserInteractionEnabled = true
            lastName.isUserInteractionEnabled = true
            street.isUserInteractionEnabled = true
            city.isUserInteractionEnabled = true
            state.isUserInteractionEnabled = true
            zipCode.isUserInteractionEnabled = true
            phoneNumber.isUserInteractionEnabled = true
            dob.isUserInteractionEnabled = true
            editBioButton.isUserInteractionEnabled = true
            editSkillsButton.isUserInteractionEnabled = true
            
            // change the picture from the edit button to the save button
            let image = UIImage(named: "editProfileSave") as UIImage?
            editOrSaveButton.setImage(image, for: .normal)
        }
    }
    
    // function to update user information
    func updateUserInfo(fname:String, lname:String, dateb:String, city:String, country:String, street:String, state:String, zip:Int, bio:String, skills:String, phone:String, linkToImg:String){
        let db = Firestore.firestore()
        guard let userID = Auth.auth().currentUser?.uid else {return}
        db.collection("users").document(userID).updateData(
            ["firstname": fname,
             "lastname": lname,
             "dateOfBirth": dateb,
             "address": [
                "city": city,
                "country": country,
                "streetAddress": street,
                "state": state,
                "zipcode": zip
             ],
             "phone": phone,
             "bio": bio,
             "skills": skills,
             "profilePicLink":linkToImg,
            ]) { (error) in
                // Dismiss loading bar
                self.activityIndicator.stopAnimating()
                if error != nil {
                    // Show error message
                    self.errorMessage.textColor = .red
                    self.errorMessage.text = "Error saving user data."
                }
                else{
                    self.errorMessage.textColor = .green
                    self.errorMessage.text = "Info updated succesfully."
                }
                
            }
        
    }
    
    func validateFields() -> String? {
        
        // Checking if all fields are filled in.
        if firstName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            dob.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            city.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            state.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            zipCode.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all required fields."
        }
        
        // TODO: Checking if their date of birth is valid
        
        let cleanedDateOfBirth = dob.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedZipCode = zipCode.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isAgeValid(date: cleanedDateOfBirth) == false {
            // Age they entered was not valid
            
            return "Please enter a valid date of birth\n(must be 18 years or older)"
        }
        
        if Utilities.isZipCodeValid(zipCode: cleanedZipCode) == false {
            // Zip code they entered was not valid
            
            return "The zip code you entered was not valid\n(must be a 5 digit U.S. zip code)"

        }
        
        if(!CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: phoneNumber.text!))){
            return "The phone number you entered was not valid\n(Phone number should be digits only)"
        }
        
        return nil
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
    
    @IBAction func dismissKeboard(_ sender: Any) {
        self.resignFirstResponder()
    }
    
    @IBAction func editBioPressed(_ sender: UIButton) {
        // User clicked on the bio textview and he doesn't have a bio already, clear the text and change color
        if(!bioExists){
            self.bioTextfield.text = ""
            self.bioTextfield.textColor = UIColor.black
        }
        // Either way, you want to hide the button and allow the user to edit the text
        self.bioTextfield.becomeFirstResponder()
        sender.isHidden = true;
    }
    @IBAction func editSkillsPressed(_ sender: UIButton) {
        // User clicked on the bio textview and he doesn't have a bio already, clear the text and change color
        if(!skillsExists){
            self.skills.text = ""
            self.skills.textColor = UIColor.black
        }
        // Either way, you want to hide the button and allow the user to edit the text
        self.skills.becomeFirstResponder()
        sender.isHidden = true;
    }
    
}


extension EditProfileViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            self.profilePic.image = pickedImage
        }
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
}


// class to handle updating the profile picture to the storage
class StorageManagager {


    private let storageRef: StorageReference

    init() {

        // first we create a reference to our storage
        // replace the URL with your firebase URL
        self.storageRef = Storage.storage().reference(forURL: "gs://developmentenvironment-224c8.appspot.com")
    }

    open func uploadData(_ imageData: Data, completion: @escaping (URL? , Error?) -> Void) {

        guard let userID = Auth.auth().currentUser?.uid else {return}
        let storageRefer = self.storageRef.child("UserPictures")
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        storageRefer.child(userID).putData(imageData, metadata: metaData) { metaData, error in
            // first we check if the error is nil
            if let error = error {
                completion(nil, error)
                return
            }
            // then we check if the metadata and path exists
            // if the error was nil, we expect the metadata and path to exist
            // therefore if not, we return an error
            guard let metadata = metaData, let _ = metadata.path else {
                completion(nil, NSError(domain: "core", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unexpected error. Path is nil."]))
                return
            }
        }
        
        
    }
}
