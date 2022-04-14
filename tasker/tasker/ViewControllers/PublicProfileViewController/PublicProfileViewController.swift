//
//  PublicProfileViewController.swift
//  tasker
//
//  Created by Kevin Babou on 2/14/22.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage

class PublicProfileViewController: UIViewController {
    var userID = ""
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var bio: UILabel!
    @IBOutlet weak var skills: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let db = Firestore.firestore()
        let storageRef = FirebaseStorage.Storage.storage().reference(forURL: "gs://developmentenvironment-224c8.appspot.com")
        let docRef = db.collection("users").document(userID)
        docRef.getDocument { snapshot, error in
                    if error != nil {
                        print("error fetching user document")
                    } else {
                        do {
                            guard let user = try snapshot!.data(as: User.self) else{return}
                            // ----- Set profile pic, check for existing, set if not empty
                            let profilepicURL:String = user.profilePicLink ?? ""
                            if(!profilepicURL.isEmpty){
                                storageRef.child("UserPictures").child(profilepicURL).getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
                                    let picture = UIImage(data: data!)
                                    self.profilePic.image = picture
                                }
                            }
                                
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

                        } catch {
                            print(error)
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
    
}
