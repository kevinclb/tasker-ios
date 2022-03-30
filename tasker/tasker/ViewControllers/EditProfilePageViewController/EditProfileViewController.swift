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

class EditProfileViewController: UIViewController {
    // var for picking an image from photo library
    var imagePicker:UIImagePickerController!
    
    // boolean to check if user clicked on edit, initially false
    var editPressed:Bool = false;
    @IBOutlet weak var editOrSaveButton: UIButton!
    
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
        editPressed = false
        
        // This is for the image stuff
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        profilePic.layer.cornerRadius = profilePic.bounds.height / 2
        profilePic.clipsToBounds = true
        
        // When the view loads, lets go to the database and get info to populate fields so user can edit them
        let db = Firestore.firestore()
        let storage = FirebaseStorage.Storage.storage()
        guard let userID = Auth.auth().currentUser?.uid else {return}
        let docRef = db.collection("users").document(userID)
        docRef.getDocument { snapshot, error in
                    if error != nil {
                        print("error fetching user document")
                    } else {
                        do {
                            guard let user = try snapshot!.data(as: User.self) else{return}
                            // ----- Set profile picture
                            let profilepicURL:String = user.profilePicLink ?? ""
                            if(!profilepicURL.isEmpty){
                                let storageRef = storage.reference(forURL: profilepicURL)
                                storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
                                    let picture = UIImage(data: data!)
                                    self.profilePic.image = picture
                                }
                            }
                                
                            // ----- Set first name
                            self.firstName.text = user.firstname
                            
                            // ----- Set last name
                            self.lastName.text = user.lastname
                            
                            // ----- Set dob
                            self.dob.text = user.dateOfBirth
                            
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
                            }
                            else{
                                self.skills.text = "You currently do not have any skills added, add some to tell people more about your skills!"
                                self.skills.textColor = UIColor.lightGray
                            }
                        } catch {
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
        // User has already chosen to edit info, so now they're clicking save, so save their changes
        if(editPressed){
            print("Saving changes")
        }
        // User just pressed the edit button to edit
        else{
            editPressed = true
            // Set the fields to editable
            bioTextfield.isEditable = true
            skills.isEditable = true
            firstName.isUserInteractionEnabled = true
            lastName.isUserInteractionEnabled = true
            dob.isUserInteractionEnabled = true
            street.isUserInteractionEnabled = true
            city.isUserInteractionEnabled = true
            state.isUserInteractionEnabled = true
            zipCode.isUserInteractionEnabled = true
            country.isUserInteractionEnabled = true
            
            // change the picture from the edit button to the save button
            let image = UIImage(named: "editProfileSave") as UIImage?
            editOrSaveButton.setImage(image, for: .normal)
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
