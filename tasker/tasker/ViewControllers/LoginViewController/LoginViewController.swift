//
//  LoginViewController.swift
//  tasker
//
//  Created by Amir Hammoud on 2/14/22.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailAddressLabel: UILabel!
    
    @IBOutlet weak var emailAddressTextField: UITextField!
    
    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var continueButton: UIButton!
    
    @IBOutlet weak var loginWithGoogleButton: UIButton!
    
    @IBOutlet weak var loginWithAppleButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if GIDSignIn.sharedInstance.currentUser != nil {
            // User signed in
        }
        else {
            self.present(LoggedOutViewController(), animated: true, completion: nil)      }

        // Do any additional setup after loading the view.
    }
    
    func validateFields() -> String? {
        
        // Checking if all fields are filled in.
        if emailAddressTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields."
        }
        
        return nil
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func continueTapped(_ sender: Any) {
        
        // Validate fields
        let error = validateFields()
        
        if error != nil {
            // There was something wrong with the fields, show error message
            Utilities.showError(message: error!, errorLabel: self.errorLabel)
        }
        else {
            // Create cleaned versions of data
            let email = emailAddressTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Signing in user
            Auth.auth().signIn(withEmail: email, password: password) { (result, err) in
                
                // Check for errors
                if err != nil{
                    Utilities.showError(message: err!.localizedDescription, errorLabel: self.errorLabel)
                }
                else {
                    
                    self.segueToHomeVC()
                }
            }
        }
    }
    
    @IBAction func loginWithGoogleTapped(_ sender: Any) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)

        // Start the google sign in flow
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [unowned self] user, err in

            if err != nil {
                Utilities.showError(message: err!.localizedDescription, errorLabel: self.errorLabel)
            return
          }

        // User authentication which will be used as credentials to sign in.
          guard
            let authentication = user?.authentication,
            let idToken = authentication.idToken
          else {
              
            return
          }
            // User's sign in credentials.
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
            
            // Signing into firebase with user's credentials that were obtained above.
            Auth.auth().signIn(with: credential) { result, err in

                // Check for errors
                if let err = err {
                    Utilities.showError(message: err.localizedDescription, errorLabel: self.errorLabel)
                }
                
                // Checking if user is new
                guard let newUserStatus = result?.additionalUserInfo?.isNewUser else {return}
                
                if newUserStatus == true {
                    // New user, have them fill out additional info
                    // Switch to setup page here
                    let setupPageVC = SetupPageViewController(fromGoogle: true, givenName: user?.profile?.givenName! ?? "", familyName: user?.profile?.familyName! ?? "")

                    setupPageVC.modalPresentationStyle = .fullScreen
                    self.present(setupPageVC, animated: true, completion: nil)
                    setupPageVC.firstNameTextField.text = user?.profile?.givenName
                    setupPageVC.lastNameTextField.text = user?.profile?.familyName
                    setupPageVC.setEmail(email: (user?.profile!.email)!);
                    setupPageVC.setGoogleCredentials(credentials: credential)
                   
                    let user = Auth.auth().currentUser

                    user?.delete { error in
                      if let err = err {
                          Utilities.showError(message: err.localizedDescription, errorLabel: self.errorLabel)
                      } else {
                        // Account deleted.
                      }
                    }
                }
                else{
                    // Not a new user, direct to home view
                    self.segueToHomeVC()
                }
            }
        }
    }
    
    func segueToHomeVC() {
        // Segue to home explore page and programatically change root view controller to home explore page
        
        let homePageVC = HomeExplorePageViewController()

        homePageVC.modalPresentationStyle = .fullScreen
        self.present(homePageVC, animated: true, completion: nil)
    }
}
