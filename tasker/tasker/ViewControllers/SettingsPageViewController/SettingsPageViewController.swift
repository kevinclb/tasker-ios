//
//  SettingsPageViewController.swift
//  tasker
//
//  Created by Kevin Babou on 2/2/22.
//

import UIKit
import FirebaseAuth

class SettingsPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
   
    @IBAction func accountSettingsTapped(_ sender: Any) {
        print("Account Settings Tapped")
    }
    @IBAction func editProfileTapped(_ sender: Any) {
        navigateTo(newViewController: EditProfileViewController(), transitionFrom: .fromRight)
    }
    @IBAction func paymentInfoTapped(_ sender: Any) {
        print("Payment Info Tapped")
    }
    @IBAction func appNotifTapped(_ sender: Any) {
        print("App Notifications Tapped")
    }
    @IBAction func helpTapped(_ sender: Any) {
        navigateTo(newViewController: HelpViewController(), transitionFrom: .fromRight)
    }
    @IBAction func logoutTapped(_ sender: Any) {
        try! Auth.auth().signOut()
        navigateTo(newViewController: LoggedOutViewController(), transitionFrom: .fromLeft)
    }
    @IBAction func employeeStatusTapped(_ sender: Any) {
        navigateTo(newViewController: EmployeeStatusViewController(), transitionFrom: .fromRight)
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
    
    func navigateTo(newViewController:UIViewController, transitionFrom:CATransitionSubtype){
        // this code here is to present from right to left instead of bottom to top
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = transitionFrom
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        
        // this code here is to make the viewcontroller we're presenting and make it show full screen then present it
        let newVC = newViewController
        newVC.modalPresentationStyle = .fullScreen
        // the app will automatically know how to animate the presentation, it will use the transition we made above on its own so that's why we set animated to false
        self.present(newVC, animated: false, completion: nil)
    }
}
