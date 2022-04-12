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
        dismiss(animated: false, completion: nil)
    }

}
