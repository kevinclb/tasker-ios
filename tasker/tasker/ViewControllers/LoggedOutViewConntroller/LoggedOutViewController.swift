//
//  LoggedOutViewController.swift
//  tasker
//
//  Created by Amir Hammoud on 2/2/22.
//

//note: this should be the root view controller


import UIKit
import Firebase
import FirebaseAuth
class LoggedOutViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    private var authListener: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }

    // Check for auth status.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        authListener = Auth.auth().addStateDidChangeListener { (auth, user) in

            if let user = user {
                let newVC = RootViewController()
                newVC.modalPresentationStyle = .fullScreen
                // the app will automatically know how to animate the presentation, it will use the transition we made above on its own so that's why we set animated to false
                self.present(newVC, animated: false, completion: nil)
            } else {
                // No user
            }
        }
    }

    // Remove the listener once it's no longer needed.
    deinit {
        if let listener = authListener {
            Auth.auth().removeStateDidChangeListener(authListener as! NSObjectProtocol)
        }
    }

    // Segue to login view controller when the login button is pressed.
    @IBAction func loginPressed(_ sender: Any) {
        let loginVC = LoginViewController()
        present(loginVC, animated: true, completion: nil)
    }
    
    // Segue to registration view controller when the register button is pressed.
    @IBAction func registerPressed(_ sender: Any) {
        let registerStep1VC = RegistrationStep1ViewController()
        present(registerStep1VC, animated: true, completion: nil)
    }
    

}

