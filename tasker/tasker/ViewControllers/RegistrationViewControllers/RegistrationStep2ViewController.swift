//
//  RegistrationStep2ViewController.swift
//  tasker
//
//  Created by Amir Hammoud on 2/10/22.
//

import UIKit

class RegistrationStep2ViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    
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

    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func continuePressed(_ sender: Any) {
        let homePageVC = HomeExplorePageViewController()
        present(homePageVC, animated: true, completion: nil)
    }
}
