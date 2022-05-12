//
//  RecentTasksRootVC.swift
//  tasker
//
//  Created by Kevin Babou on 4/5/22.
//

import UIKit

class RecentTasksRootVC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let recentTasksVC = RecentTasksTableViewController()
        recentTasksVC.title = "Recent Tasks"
        recentTasksVC.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backBarButtonPressed))
        self.navigationBar.tintColor = UIColor(named: "Accent Color")
        self.setViewControllers([recentTasksVC], animated: true)
        // Do any additional setup after loading the view.
    }

    @objc func backBarButtonPressed() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = .fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        // this code here is to make the viewcontroller we're presenting and make it show full screen then present it
        let homeVC = RootViewController()
        homeVC.modalPresentationStyle = .fullScreen
        // the app will automatically know how to animate the presentation, it will use the transition we made above on its own so that's why we set animated to false
        present(homeVC, animated: false, completion: nil)
    }

}
