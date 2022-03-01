//
//  RegistrationStep2ViewController.swift
//  tasker
//
//  Created by Amir Hammoud on 2/10/22.
//

import UIKit

class RegistrationStep2ViewController: UIViewController {
    
    @IBOutlet weak var firstNameLabel: UILabel!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameLabel: UILabel!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var dateOfBirthLabel: UILabel!
    
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var cityTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var continueButton: UIButton!
    
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
    
    @IBAction func continuePressed(_ sender: Any) {
        let employeeHomePageVC = EmployeeExplorePageViewController()
        employeeHomePageVC.modalPresentationStyle = .fullScreen
        present(employeeHomePageVC, animated: true, completion: nil)
    }
}
