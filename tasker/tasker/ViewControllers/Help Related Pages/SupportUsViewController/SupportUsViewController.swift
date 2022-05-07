//
//  SupportUsViewController.swift
//  tasker
//
//  Created by User on 3/17/22.
//

import UIKit

class SupportUsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func contactUsTapped(_ sender: Any) {
        // when user wants to get in touch we'll load the contact us view controller
        let vc = ContactUsViewController()
        present(vc, animated: true, completion: nil)
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
