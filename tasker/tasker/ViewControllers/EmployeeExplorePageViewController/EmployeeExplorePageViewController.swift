//
//  EmployeeExplorePageViewController.swift
//  tasker
//
//  Created by Kevin Babou on 2/2/22.
//
import Firebase
import FirebaseFirestore
import UIKit

let db = Firestore.firestore()

class EmployeeExplorePageViewController: UIViewController {
        
    
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet weak var menuScrollView: UIScrollView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var menuLeading: NSLayoutConstraint!
    @IBOutlet weak var menuTrailing: NSLayoutConstraint!
    
    let taskCollectionViewCellId = "MyCollectionViewCell"
    
    var tasks = [Errand]()
    var menuOut = false
    override func viewDidLoad() {
        // This is for the slide out menu
        menuScrollView.bounces = false
        menuScrollView.showsVerticalScrollIndicator = false
        menuScrollView.showsHorizontalScrollIndicator = false

        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        leftSwipe.direction = .left
        view.addGestureRecognizer(leftSwipe)
        
        // code for employeePage
        let nibCell = UINib(nibName: taskCollectionViewCellId, bundle: nil)
        collectionView.register(nibCell, forCellWithReuseIdentifier: taskCollectionViewCellId)
        collectionView.delegate = self
        collectionView.dataSource = self
        MyCollectionViewCell.awakeFromNib()
        
        db.collection("tasks").getDocuments { (snapshot, error) in
            if error != nil {
                print("error retrieving task(errand) documents: \(String(describing: error?.localizedDescription))")
            } else {
                for d in (snapshot!.documents) {
                    do {
                        try self.tasks.append(d.data(as: Errand.self)!)
                    } catch {
                        print("error decoding task(errand) document")
                    }
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    // functions for slide out menu
    
    @IBAction func menuTapped(_ sender: Any) {
        if(menuOut == false){
            setView(view: menuScrollView, hidden: false)
            menuLeading.constant = 0
            menuTrailing.constant = 0
            menuOut = true
        }
        else{
            setView(view: menuScrollView, hidden: true)
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
                    setView(view: menuScrollView, hidden: true)
                    menuLeading.constant = -300
                    menuTrailing.constant = 300
                    menuOut = false
                }
            }
        }
    }
    
    // IB Actions for menu buttons
    
    @IBAction func helpCenterTapped(_ sender: Any) {
        navigateTo(newViewController: HelpViewController(), transitionFrom: .fromRight)
    }
    @IBAction func referAfriendTapped(_ sender: Any) {
        print("Refer a Friend Tapped")
    }
    @IBAction func faqTapped(_ sender: Any) {
        navigateTo(newViewController: FAQViewController(), transitionFrom: .fromRight)
    }
    @IBAction func contactUsTapped(_ sender: Any) {
        navigateTo(newViewController: ContactUsViewController(), transitionFrom: .fromRight)
    }
    @IBAction func aboutUsTapped(_ sender: Any) {
        navigateTo(newViewController: AboutUsViewController(), transitionFrom: .fromRight)
    }
    @IBAction func supportUsTapped(_ sender: Any) {
        navigateTo(newViewController: SupportUsViewController(), transitionFrom: .fromRight)
    }
    @IBAction func clientProfileTapped(_ sender: Any) {
        navigateTo(newViewController: RootViewController(), transitionFrom: .fromRight)
    }
    @IBAction func settingsTapped(_ sender: Any) {
        navigateTo(newViewController: SettingsPageViewController(), transitionFrom: .fromRight)
    }
    @IBAction func logoutTapped(_ sender: Any) {
        print("Logout Tapped")
    }
    // function to use to navigate to other pages from homepage
    func navigateTo(newViewController:UIViewController, transitionFrom:CATransitionSubtype){
        // Close the menu so when we return it's not open
        setView(view: menuScrollView, hidden: true)
        menuLeading.constant = -300
        menuTrailing.constant = 300
        menuOut = false
        // this code here is to present from right to left instead of bottom to top
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = transitionFrom
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        
        // this code here is to make the viewcontroller we're presenting and make it show full screen then present it
        let newVC = newViewController
        newVC.modalPresentationStyle = .fullScreen
        // the app will automatically know how to animate the presentation, it will use the transition we made above on its own so that's why we set animated to false
        self.present(newVC, animated: false, completion: nil)
    }
    
}

extension EmployeeExplorePageViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: taskCollectionViewCellId, for: indexPath) as! MyCollectionViewCell
        let task = tasks[indexPath.row]
        cell.lbName.text = task.title
        cell.lbCity.text = task.location?.city ?? "no city"
        cell.lbDesc.text = task.taskDescription
        cell.lbPrice.text = String(task.price!)
        cell.lbCategory.text = task.category
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let task = tasks[indexPath.row]
            print("\(indexPath.row) - \(task.title)")
        }
    
    //fixing an issue
    
}
