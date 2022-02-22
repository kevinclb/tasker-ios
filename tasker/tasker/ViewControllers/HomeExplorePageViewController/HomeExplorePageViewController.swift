//
//  HomeExplorePageViewController.swift
//  tasker
//
//  Created by Kevin Babou on 2/2/22.
//

import UIKit

class HomeExplorePageViewController: UIViewController {

    //Outlets for each button on the menu
    @IBOutlet weak var helpCenterButton: UIButton!
    @IBOutlet weak var referAFriend: UIButton!
    @IBOutlet weak var faq: UIButton!
    @IBOutlet weak var contactUs: UIButton!
    @IBOutlet weak var aboutUs: UIButton!
    @IBOutlet weak var supportUs: UIButton!
    @IBOutlet weak var employeeProfile: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    // Outlets for the menu for animation purposes
    @IBOutlet weak var menuScroll: UIScrollView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var menuLeading: NSLayoutConstraint!
    @IBOutlet weak var menuTrailing: NSLayoutConstraint!
    
    
    var menuOut = false
    override func viewDidLoad() {
        super.viewDidLoad()
        menuScroll.bounces = false
        menuScroll.showsVerticalScrollIndicator = false
        menuScroll.showsHorizontalScrollIndicator = false
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        leftSwipe.direction = .left
        view.addGestureRecognizer(leftSwipe)
        
    }

    @IBAction func menuTapped(_ sender: Any) {
        if(menuOut == false){
            setView(view: menuScroll, hidden: false)
            menuLeading.constant = 0
            menuTrailing.constant = 0
            menuOut = true
        }
        else{
            setView(view: menuScroll, hidden: true)
            menuLeading.constant = -300
            menuTrailing.constant = 300
            menuOut = false
        }
        
    }
    func setView(view: UIScrollView, hidden: Bool) {
        UIScrollView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            view.isHidden = hidden
        })
    }
    
    @objc func handleSwipe(sender: UISwipeGestureRecognizer){
        if sender.state == .ended {
            if(sender.direction == .left){
                if menuOut{
                    setView(view: menuScroll, hidden: true)
                    menuLeading.constant = -300
                    menuTrailing.constant = 300
                    menuOut = false
                }
            }
        }
    }
    
    @IBAction func helpCenterTapped(_ sender: Any) {
    }
    
    @IBAction func referAFriendTapped(_ sender: Any) {
    }
    
    @IBAction func faqTapped(_ sender: Any) {
    }
    
    @IBAction func contactUsTapped(_ sender: Any) {
    }
    
    @IBAction func aboutUsTapped(_ sender: Any) {
    }
    
    @IBAction func supportUsTapped(_ sender: Any) {
    }
    
    @IBAction func employeeProfileTapped(_ sender: Any) {
    }
    
    @IBAction func settingsTapped(_ sender: Any) {
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
    }
    
    
}
