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
        let homePageVC = HomeExplorePageViewController()
        homePageVC.modalPresentationStyle = .fullScreen
        self.present(homePageVC, animated: true)
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
