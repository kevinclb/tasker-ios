//
//  LoggedOutViewController.swift
//  tasker
//
//  Created by Kevin Babou on 2/2/22.
//

//note: this should be the root view controller


import UIKit

class LoggedOutViewController: UIViewController {

    private var registerButton: RegisterButton = {
        let button = RegisterButton(frame: CGRect(x: 0, y: 0, width: 167, height: 52))
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(registerButton)
        registerButton.center = view.center
        registerButton.gradientLayer.cornerRadius = 6
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
