//
//  LoggedOutViewController.swift
//  tasker
//
//  Created by Kevin Babou on 2/2/22.
//

//note: this should be the root view controller


import UIKit

class LoggedOutViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var registerButton: UIButton!
    
    let loginVC = LoginViewController()
    let registrationVC = RegistrationStep1ViewController()
    
    
    override func viewDidLoad() {
   
        
        //I'm giving these views a set x and y coordinate for now,
        //however, the correct way to lay these buttons vertical to one another
        //is to use a vertical UIStackView.
        
        super.viewDidLoad()
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func loginPressed(_ sender: Any) {
        let loginVC = LoginViewController()
        present(loginVC, animated: true, completion: nil)
    }
    
    @IBAction func registerPressed(_ sender: Any) {
        let registerStep1VC = RegistrationStep1ViewController()
        present(registerStep1VC, animated: true, completion: nil)
    }
    

}

