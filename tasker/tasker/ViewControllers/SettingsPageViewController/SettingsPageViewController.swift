//
//  SettingsPageViewController.swift
//  tasker
//
//  Created by Kevin Babou on 2/2/22.
//

import UIKit

class SettingsPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
   
    @IBAction func accountSettingsTapped(_ sender: Any) {
        
    }
    @IBAction func editProfileTapped(_ sender: Any) {
        // this code here is to present from right to left instead of bottom to top
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        
        // this code here is to make the viewcontroller we're presenting and make it show full screen then present it
        let newViewController = EditProfileViewController()
        newViewController.modalPresentationStyle = .fullScreen
        // the app will automatically know how to animate the presentation, it will use the transition we made above on its own so that's why we set animated to false
        self.present(newViewController, animated: false, completion: nil)
    }
    @IBAction func paymentInfoTapped(_ sender: Any) {
        
    }
    @IBAction func appNotifTapped(_ sender: Any) {
        
    }
    @IBAction func helpTapped(_ sender: Any) {
        
    }
    @IBAction func logoutTapped(_ sender: Any) {
    }
}
