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
    
    
    // outlets for components to populate
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var dob: UITextField!
    @IBOutlet weak var bioTextfield: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // This is for the image stuff
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        profilePic.layer.cornerRadius = profilePic.bounds.height / 2
        profilePic.clipsToBounds = true
        
        // When the view loads, lets go to the database and get info to populate fields so user can edit them
        var user = User()
        let db = Firestore.firestore()
        guard let userID = Auth.auth().currentUser?.uid else {return}
        let docRef = db.collection("users").document(userID)
        docRef.getDocument { snapshot, error in
            if error != nil {
                print("error")
            } else {
                do {
                    user = try snapshot!.data(as: User.self)!
                } catch {
                    print("error decoding user object")
                }
                user.address?.state
                user.address?.city
            }
        }
        
//        docRef.getDocument { (document, error) in
//            if let document = document, document.exists {
//                // Set the first name
//                let fname = document.get("firstname") as! String
//                self.firstName.text = fname
//                // Set the last name
//                let lname = document.get("lastname") as! String
//                self.lastName.text = lname
//                // Set the Date of Birth
//                let dateob = document.get("dateOfBirth") as! String
//                self.dob.text = dateob
//                // Set the address
//
//                // Set the bio
//                let bio:String = document.get("bio") as! String
//                if(!bio.isEmpty){
//                    self.bioTextfield.text = bio
//                    self.bioTextfield.textColor = UIColor.black
//                }
//                else{
//                    self.bioTextfield.text = "You currently do not have a bio, add one to tell people more about you!"
//                    self.bioTextfield.textColor = UIColor.lightGray
//                }
//                // Set the skills
//            } else {
//                print("Document does not exist")
//            }
//        }
        
    }
   
    @IBAction func editImagePressed(_ sender: Any) {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func saveChangesTapped(_ sender: Any) {
        
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
