//
//  HomeExplorePageViewController.swift
//  tasker
//
//  Created by Kevin Babou on 2/2/22.
//

import UIKit

class HomeExplorePageViewController: UIViewController {
    
    var taskers = [User]()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var HomePageCollectionView: UICollectionView!
    let taskerCollectionViewCellId = "TaskerCollectionViewCell"
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
        
        let nibCell = UINib(nibName: taskerCollectionViewCellId, bundle: nil)
        HomePageCollectionView.register(nibCell, forCellWithReuseIdentifier: taskerCollectionViewCellId)
        HomePageCollectionView.delegate = self
        HomePageCollectionView.dataSource = self
        searchBar.delegate = self
        TaskerCollectionViewCell.awakeFromNib()
        
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        leftSwipe.direction = .left
        view.addGestureRecognizer(leftSwipe)
        
        db.collection("users").getDocuments { (snapshot, error) in
            if error != nil {
                print(error)
            } else {
                for d in (snapshot?.documents)! {
                    self.taskers.append(User(firstname: d["firstname"] as? String ?? "", city: d["city"] as? String ?? "", rating: d["rating"] as? Int ?? 0,
                                             employeeDescription: d["employeeDescription"] as? String ?? ""))
                    DispatchQueue.main.async {
                        self.HomePageCollectionView.reloadData()
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
    
    @IBAction func helpCenterTapped(_ sender: Any) {
        print("Help Center Tapped")
    }
    
    @IBAction func referAFriendTapped(_ sender: Any) {
        print("Refer a Friend Tapped")
    }
    
    @IBAction func FAQTapped(_ sender: Any) {
        print("FAQ Tapped")
    }
    
    @IBAction func contactUsTapped(_ sender: Any) {
        print("Contact Us Tapped")
    }
    
    @IBAction func aboutUsTapped(_ sender: Any) {
        print("About Us Tapped")
    }
    
    @IBAction func supportUsTapped(_ sender: Any) {
        print("Support Us Tapped")
    }
    
    @IBAction func employeeProfileTapped(_ sender: Any) {
        print("Employee Profile Tapped")
    }
    
    @IBAction func settingsTapped(_ sender: Any) {
        print("Settings Tapped")
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        print("Logout Tapped")
    }
    
    
}

extension HomeExplorePageViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return taskers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: taskerCollectionViewCellId, for: indexPath) as! TaskerCollectionViewCell
        let tasker = taskers[indexPath.row]
        cell.taskerName.text = tasker.firstname!
        cell.taskerCity.text = tasker.city!
        cell.taskerRating.text = String(tasker.rating!)
        cell.taskerDescription.text = tasker.employeeDescription!
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tasker = taskers[indexPath.row]
        print("\(indexPath.row) - \(tasker.firstname!)")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let noOfCellsInRow = 1

        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))

        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
           return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        }
    
    //fixing an issue
    
}

extension HomeExplorePageViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("text did change")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        navigateTo(newViewController: SearchResultsTableViewController(), transitionFrom: .fromBottom)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("Text did end editing")
    }
    
    func navigateTo(newViewController:UIViewController, transitionFrom:CATransitionSubtype){
        // this code here is to present from right to left instead of bottom to top
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = transitionFrom
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        
        // this code here is to make the viewcontroller we're presenting and make it show full screen then present it
        let newVC = newViewController
        newVC.modalPresentationStyle = .popover
        // the app will automatically know how to animate the presentation, it will use the transition we made above on its own so that's why we set animated to false
        self.present(newVC, animated: false, completion: nil)
    }
}
