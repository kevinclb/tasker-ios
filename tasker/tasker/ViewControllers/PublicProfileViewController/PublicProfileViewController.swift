//
//  PublicProfileViewController.swift
//  tasker
//
//  Created by Kevin Babou on 2/14/22.
//

import UIKit

class PublicProfileViewController: UIViewController {
    var uid = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        uid = Utilities.getUid()
        view.backgroundColor = .systemBlue
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

}
