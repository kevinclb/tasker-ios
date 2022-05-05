//
//  RootViewController.swift
//  tasker
//
//  Created by Kevin Babou on 2/14/22.
//

import UIKit
import FirebaseAuth

class EmployeeRootViewController: UITabBarController {
    var uid = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: pass this to homepage
        guard (Auth.auth().currentUser) != nil else {
            print("error: no current user logged into app.")
            return
        }
        uid = Utilities.getUid()
        // Create instance of view controllers
        let homeVC = EmployeeExplorePageViewController()
        let messagesVC = MessagesViewController()
        let profileVC = PublicProfileViewController()
        
        homeVC.title = "Home"
        messagesVC.title = "Messages"
        profileVC.title = "Profile"
        // assign view controllers to tab bar
        
        self.setViewControllers([homeVC, messagesVC, profileVC], animated: false)
        
        guard let items = self.tabBar.items else {
            return
        }
        
        let images = ["home icon", "messages icon", "profile icon"]
        for x in 0...2 {
            items[x].image = UIImage(named: images[x])
        }
        
        self.tabBar.tintColor = .systemGreen
        self.tabBar.backgroundColor = .white
    }

    
    

    
}
