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
import FBSDKLoginKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailAddressLabel: UILabel!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var loginWithGoogleButton: UIButton!
    @IBOutlet weak var loginWithFacebookButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if GIDSignIn.sharedInstance.currentUser != nil {
            // User signed in
        }
        else {
            self.present(LoggedOutViewController(), animated: true, completion: nil)      }
    }
    
    func validateFields() -> String? {
        
        // Prompting the user to fill in all text fields if any are left blank.
        if emailAddressTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields."
        }
        
        return nil
    }
    
    
    // Function for when the continue button is tapped
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
    
    // Function for when the login with Google button is tapped.
    @IBAction func loginWithGoogleTapped(_ sender: Any) {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)

        // Start the google sign in flow.
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

                // Check for errors.
                if let err = err {
                    Utilities.showError(message: err.localizedDescription, errorLabel: self.errorLabel)
                }
                
                // Checking if user is new.
                guard let newUserStatus = result?.additionalUserInfo?.isNewUser else {return}
                
                if newUserStatus == true {
                    
                    // New user, have them fill out additional info, transfer data and segue to setup view
                    let setupPageVC = SetupPageViewController(fromThirdParty: true, givenName: user?.profile?.givenName! ?? "", familyName: user?.profile?.familyName! ?? "")
                    
                    // Segueing and sending data to the setup page view controller.
                    self.present(setupPageVC, animated: true, completion: nil)
                    setupPageVC.firstNameTextField.text = user?.profile?.givenName
                    setupPageVC.lastNameTextField.text = user?.profile?.familyName
                    setupPageVC.setEmail(email: (user?.profile!.email)!);
                    setupPageVC.setCredentials(credentials: credential)
                   
                    let user = Auth.auth().currentUser

                    // Delete user from database if they do not complete the setup page.
                    user?.delete { error in
                      if let err = err {
                          Utilities.showError(message: err.localizedDescription, errorLabel: self.errorLabel)
                      } else {
                        // Account deleted.
                      }
                    }
                }
                else{
                    
                    // Not a new user, direct to home view.
                    self.segueToHomeVC()
                }
            }
        }
    }
    
    // Function for when the login with Facebook button is tapped.
    @IBAction func loginWithFacebookTapped(_ sender: Any) {
        
        // Start the Facebook sign in flow.
        LoginManager().logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
          if error != nil {

            Utilities.showError(message: error!.localizedDescription, errorLabel: self.errorLabel)
          }
            else if result?.isCancelled == true {
              
              Utilities.showError(message: "Facebook login was cancelled.", errorLabel: self.errorLabel)
          }
            else {
              
              // Pulling data from Facebook user.
              GraphRequest(graphPath: "/me", parameters: ["fields": "first_name, last_name, email"]).start {
                (connection, result, err) in

                if err == nil {
                    
                  // Converting data to Strings so we can use them later.
                  let data: [String: AnyObject] = result as! [String: AnyObject]

                    guard let accessTokenString = AccessToken.current?.tokenString else { return }
                  let credential = FacebookAuthProvider.credential(withAccessToken: accessTokenString)

                  // Signing into firebase with user's credentials that were obtained above.
                  Auth.auth().signIn(with: credential) { result, err in
                      
                    // Check for errors.
                    if let err = err {
                      Utilities.showError(message: err.localizedDescription, errorLabel: self.errorLabel)
                    }

                    // Checking if user is new.
                    guard let newUserStatus = result?.additionalUserInfo?.isNewUser else { return }

                    if newUserStatus == true {
                        
                      // New user, have them fill out additional info, transfer data and segue to setup view.
                      let setupPageVC = SetupPageViewController(
                        fromThirdParty: true, givenName: data["first_name"] as? String,
                        familyName: data["last_name"] as? String)
                        
                      // Segueing and sending data to the setup page view controller.
                      self.present(setupPageVC, animated: true, completion: nil)
                      setupPageVC.firstNameTextField.text = data["first_name"] as? String
                      setupPageVC.lastNameTextField.text = data["last_name"] as? String
                      setupPageVC.setEmail(email: (data["email"] as? String)!)
                      setupPageVC.setCredentials(credentials: credential)

                      let user = Auth.auth().currentUser

                      // Delete user from database if they do not complete the setup page.
                      user?.delete { error in
                        if let err = err {
                          Utilities.showError(message: err.localizedDescription, errorLabel: self.errorLabel)
                        } else {
                          // Account deleted.
                        }
                      }
                    } else {
                      // Not a new user, direct to home view.
                      self.segueToHomeVC()
                    }
                  }
                }
              }
            }
          }
      }
    
    func segueToHomeVC() {
        // Segue to home explore page and programatically change root view controller to home explore page
        let homePageVC = RootViewController()
        homePageVC.modalPresentationStyle = .fullScreen
        self.present(homePageVC, animated: true, completion: nil)
    }
}
