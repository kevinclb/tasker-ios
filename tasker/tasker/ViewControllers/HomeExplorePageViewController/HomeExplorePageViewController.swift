//
//  HomeExplorePageViewController.swift
//  tasker
//
//  Created by Kevin Babou on 2/2/22.
//

import UIKit

class HomeExplorePageViewController: UIViewController {

    @IBOutlet weak var exploreButton: UIButton!
    
    
    @IBOutlet weak var menuView: UIView!
    
    @IBOutlet weak var menuTrailing: NSLayoutConstraint!
    @IBOutlet weak var menuLeading: NSLayoutConstraint!
    var menuOut = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func menuTapped(_ sender: Any) {
        /*
        let vc = MenuViewController()
        //self.present(vc, animated: true, completion: nil)
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        present(vc, animated: false, completion: nil)
        */
        if(menuOut == false){
            setView(view: menuView, hidden: false)
            menuLeading.constant = 300
            menuTrailing.constant = -300
            menuOut = true
        }
        else{
            setView(view: menuView, hidden: true)
            menuLeading.constant = 0
            menuTrailing.constant = 0
            menuOut = false
        }
        
    }
    func setView(view: UIView, hidden: Bool) {
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            view.isHidden = hidden
        })
    }
}
