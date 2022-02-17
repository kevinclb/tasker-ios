//
//  LoginPageViewController.swift
//  tasker
//
//  Created by Amir Hammoud on 2/14/22.
//

import UIKit

class LoginPageViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var emailAddressLabel: UILabel!
    
    @IBOutlet weak var emailAddressTextField: UITextField!
    
    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var continueButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func backPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func continueTapped(_ sender: Any) {
        let homePageVC = HomeExplorePageViewController()
        present(homePageVC, animated: true, completion: nil)
    }
    
    
}
