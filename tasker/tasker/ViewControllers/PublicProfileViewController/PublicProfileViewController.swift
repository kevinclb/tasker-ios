//
//  PublicProfileViewController.swift
//  tasker
//
//  Created by Kevin Babou on 2/14/22.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

class PublicProfileViewController: UIViewController {
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var bio: UILabel!
    @IBOutlet weak var skills: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilePic.layer.cornerRadius = profilePic.bounds.height / 2
        profilePic.clipsToBounds = true
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        // Do any additional setup after loading the view.
        activityIndicator.startAnimating()
        let db = Firestore.firestore()
        let storageRef = FirebaseStorage.Storage.storage().reference(forURL: "gs://developmentenvironment-224c8.appspot.com")
        guard let userID = Auth.auth().currentUser?.uid else {return}
        let docRef = db.collection("users").document(userID)
        docRef.getDocument { snapshot, error in
                    if error != nil {
                        print("error fetching user document")
                    } else {
                        do {
                            guard let user = try snapshot!.data(as: User.self) else{return}
                                
                            // ----- Set first name
                            self.name.text = user.firstname! + " " + user.lastname!
                            
                            // ----- Set address
                            let str = user.address?.streetAddress
                            var location:String = ""
                            let cit = user.address?.city
                            if(!cit!.isEmpty){
                                location += cit!
                            }
                            let statee = user.address?.state
                            if(!statee!.isEmpty){
                                location += statee!
                            }
                            self.city.text = location
                            // ----- Set bio
                            let bio:String = user.bio ?? ""
                            if(!bio.isEmpty){
                                self.bio.text = bio
                                self.bio.textColor = UIColor.black
                            }
                            else{
                                self.bio.text = "This user has no bio listed or added!"
                                self.bio.textColor = UIColor.lightGray
                            }
                            
                            // ----- Set skills
                            let skill:String = user.skills ?? ""
                            if(!skill.isEmpty){
                                self.skills.text = skill
                                self.skills.textColor = UIColor.black
                            }
                            else{
                                self.skills.text = "This user has no skills listed or added!"
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
                            print(error)
                    }
                }
        }
    }
    
}
