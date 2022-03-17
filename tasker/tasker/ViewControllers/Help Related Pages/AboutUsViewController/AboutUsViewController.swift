//
//  AboutUsViewController.swift
//  tasker
//
//  Created by User on 3/17/22.
//

import UIKit

class AboutUsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }


    @IBAction func goToContactUs(_ sender: UIButton) {
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
