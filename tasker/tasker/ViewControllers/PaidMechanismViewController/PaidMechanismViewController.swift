//
//  PaidMechanismViewController.swift
//  tasker
//
//  Created by Amir Hammoud on 4/15/22.
//

import UIKit
import Firebase

class PaidMechanismViewController: UIViewController {
    
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBOutlet weak var backButton: UIButton!
    
    private var taskID: String = ""
    
    func setTaskID(taskID: String) {
        self.taskID = taskID
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        
        let db = Firestore.firestore()
        db.collection("tasks").document(taskID).setData(["hasPaid": true], merge: true)
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = .fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        // this code here is to make the viewcontroller we're presenting and make it show full screen then present it
        let recentTasksVC = RecentTasksTableViewController()
        recentTasksVC.modalPresentationStyle = .fullScreen
        // the app will automatically know how to animate the presentation, it will use the transition we made above on its own so that's why we set animated to false
        present(recentTasksVC, animated: false, completion: nil)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = .fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false, completion: nil)
        
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
