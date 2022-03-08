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
    
    var tasks = [Task]()
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
                        print(error)
                    } else {
                        for d in (snapshot?.documents)! {
                            self.tasks.append(Task(name: d["name"] as? String ?? "", city: d["city"] as? String ?? "", taskInfo: d["desc"] as? String ?? "", price: d["rate"] as? String ?? "", category: d["category"] as? String ?? ""))
                                DispatchQueue.main.async {
                                    self.collectionView.reloadData()
                                }
                            }
                        }
                    }
        //collectionView.reloadData()
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
        print("Help Center Tapped")
    }
    @IBAction func referAfriendTapped(_ sender: Any) {
        print("Refer a Friend Tapped")
    }
    @IBAction func faqTapped(_ sender: Any) {
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
    @IBAction func clientProfileTapped(_ sender: Any) {
        print("Client Profile Tapped")
    }
    @IBAction func settingsTapped(_ sender: Any) {
        print("Settings Tapped")
    }
    @IBAction func logoutTapped(_ sender: Any) {
        print("Logout Tapped")
    }
    
}

extension EmployeeExplorePageViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: taskCollectionViewCellId, for: indexPath) as! MyCollectionViewCell
        let task = tasks[indexPath.row]
        cell.lbName.text = task.name!
        cell.lbCity.text = task.city!
        cell.lbDesc.text = task.taskInfo!
        cell.lbPrice.text = task.price!
        cell.lbCategory.text = task.category!
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let task = tasks[indexPath.row]
            print("\(indexPath.row) - \(task.name!)")
        }
    
    //fixing an issue
    
}
