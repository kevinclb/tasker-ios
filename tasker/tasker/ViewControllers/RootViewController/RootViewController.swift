//
//  RootViewController.swift
//  tasker
//
//  Created by Kevin Babou on 2/14/22.
//

import UIKit

class RootViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create instance of view controllers
        let homeVC = HomeExplorePageViewController()
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
        
        let images = ["Home-Icon-Gray", "Message-Icon-Gray", "Profile-Icon-Gray"]
        for x in 0...2 {
            items[x].image = UIImage(named: images[x])
        }
        
        self.tabBar.tintColor = .systemGreen
        self.tabBar.backgroundColor = .white
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
