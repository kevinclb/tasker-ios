//
//  HomeExplorePageViewController.swift
//  tasker
//
//  Created by Kevin Babou on 2/2/22.
//

import UIKit

class HomeExplorePageViewController: UIViewController {
    
    var taskers = [User]()
    @IBOutlet weak var HomePageCollectionView: UICollectionView!
    
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
        
        db.collection("Users").getDocuments { (snapshot, error) in
            if error != nil {
                print(error)
            } else {
                for d in (snapshot?.documents)! {
                    self.taskers.append(User(firstname: d["firstname"] as? String ?? "", lastname: d["lastname"] as? String ?? "", employee: d["desc"] as? Bool ?? false))
                    DispatchQueue.main.async {
                        //                                    self.collectionView.reloadData()
                    }
                }
            }
        }
    }
    //collectionView.reloadData()    }
    
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
    
    @IBAction func exploreTapped(_ sender: Any) {
    }
    
    @IBAction func recentTasksTapped(_ sender: Any) {
    }
    
    @IBAction func favoriteTasksTapped(_ sender: Any) {
    }
    
    @IBAction func needboardsTapped(_ sender: Any) {
    }
    
    @IBAction func communityTapped(_ sender: Any) {
    }
    
    @IBAction func helpCenterTapped(_ sender: Any) {
    }
    
    @IBAction func employeeProfileTapped(_ sender: Any) {
    }
    
    @IBAction func settingsTapped(_ sender: Any) {
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
    }
    
    
}
