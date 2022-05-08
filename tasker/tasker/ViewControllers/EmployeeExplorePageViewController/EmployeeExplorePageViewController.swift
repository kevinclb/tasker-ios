//
//  EmployeeExplorePageViewController.swift
//  tasker
//
//  Created by Kevin Babou on 2/2/22.
//
import Firebase
import FirebaseFirestore
import FirebaseStorage
import UIKit

let db = Firestore.firestore()

class EmployeeExplorePageViewController: UIViewController {
    
    public var completion:(([Errand]?) -> Void)?
    
    @IBOutlet var collectionViewA: UICollectionView!
    @IBOutlet var nearByColView: UICollectionView!
    @IBOutlet var negotiableColView: UICollectionView!
    
    // Outlets for menu
    @IBOutlet weak var menuScrollView: UIScrollView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var menuLeading: NSLayoutConstraint!
    @IBOutlet weak var menuTrailing: NSLayoutConstraint!
    
    // Outlets for profile pictures
    @IBOutlet weak var menuProfilePic: UIImageView!
    @IBOutlet weak var profilePic: UIImageView!
    
    // Outlets for profile info, name, rating, etc.
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var rating: UILabel!
    
    var userCity = ""
    
    let taskCollectionViewCellId = "MyCollectionViewCell"
    
    var skillsTasks = [Errand]()
    var tasks = [Errand]()
    var nearByTasks = [Errand]()
    var negotiableTasks = [Errand]()
    var menuOut = false
    override func viewDidLoad() {
        guard let userID = Auth.auth().currentUser?.uid else {return}
        
        // This is for the slide out menu
        menuScrollView.bounces = false
        menuScrollView.showsVerticalScrollIndicator = false
        menuScrollView.showsHorizontalScrollIndicator = false
        
        // for profile pictures, the one on the menu and the one on the main page
        // We want to show them rounded instead of rectangle
        self.profilePic.layer.borderWidth = 1.0
        self.profilePic.layer.masksToBounds = false
        self.profilePic.layer.borderColor = UIColor.white.cgColor
        self.profilePic.layer.cornerRadius = self.profilePic.frame.size.width / 2
        self.profilePic.clipsToBounds = true
        self.menuProfilePic.layer.borderWidth = 1.0
        self.menuProfilePic.layer.masksToBounds = false
        self.menuProfilePic.layer.borderColor = UIColor.white.cgColor
        self.menuProfilePic.layer.cornerRadius = self.profilePic.frame.size.width / 2
        self.menuProfilePic.clipsToBounds = true

        // This is for the user to be able to swipe left to close the menu
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        leftSwipe.direction = .left
        view.addGestureRecognizer(leftSwipe)
        
        // code for employeePage
        //Collection View for Catered to User
        let nibCell = UINib(nibName: taskCollectionViewCellId, bundle: nil)
        collectionViewA.register(nibCell, forCellWithReuseIdentifier: taskCollectionViewCellId)
        collectionViewA.delegate = self
        collectionViewA.dataSource = self
        MyCollectionViewCell.awakeFromNib()
        
        //Collection View for NearBy
        nearByColView.register(nibCell, forCellWithReuseIdentifier: taskCollectionViewCellId)
        nearByColView.delegate = self
        nearByColView.dataSource = self
        
        //Collection View for Negotiable
        negotiableColView.register(nibCell, forCellWithReuseIdentifier: taskCollectionViewCellId)
        negotiableColView.delegate = self
        negotiableColView.dataSource = self
        
        DispatchQueue.main.async {
        //Gets the Users city
        let cityRef = db.collection("users").document(userID)
        cityRef.getDocument{(document, error) in
            if let document = document, document.exists{
                let results = document.data()
                if let addressData = results?["address"] as? [String: Any]{
                    self.userCity = addressData["city"] as? String ?? "Washington"
                }
                print ("User city is : " + self.userCity)
                print ("User id is:" + userID)
            } else {
                print ("Document does not exist")
            }
        }
        }
        
        //gets all task
        //.wherefield if uncommented will only get tasks that do not have an employee assigned
        db.collection("tasks")/*.whereField("employeeID", isEqualTo: "")*/.getDocuments { (snapshot, error) in
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
                        //tasks in users city
                        for t in self.tasks {
                            print("this is the city" + self.userCity)
                            if (t.location?.city == self.userCity)
                            {
                            self.nearByTasks.append(t);
                                print("Nearby count is " + String(self.nearByTasks.count))
                            }
                            else if(t.location?.city == "Washington")
                            {
                                self.nearByTasks.append(t);
                                    print("Nearby count is " + String(self.nearByTasks.count))
                            }
                        }
                            //tasks that are negotiable
                            for t in self.tasks{
                                if (t.negotiable == true)
                                {
                                    self.negotiableTasks.append(t)
                                    print("Neg count is " + String(self.negotiableTasks.count))
                                }
                            }
                            for t in self.tasks{
                                if ((t.category == "Programming") || (t.category == "engineering"))
                                {
                                    self.skillsTasks.append(t)
                                    print("skills count is " + String(self.skillsTasks.count))
                                }
                            }
                    self.collectionViewA.reloadData()
                    self.nearByColView.reloadData()
                    self.negotiableColView.reloadData()
                    }
                }
            }
        
        // Code to load the profile pictures and profile info to the menu
        //guard let userID = Auth.auth().currentUser?.uid else {return}
        let docReff = db.collection("users").document(userID)
        let storageRef = FirebaseStorage.Storage.storage().reference(forURL: "gs://developmentenvironment-224c8.appspot.com")
        docReff.getDocument { snapshot, error in
                    if error != nil {
                        print("error fetching user document")
                    } else {
                        do {
                            guard let user = try snapshot!.data(as: User.self) else{return}
                            // ----- Set profile pic, check for existing, set if not empty
                            let profilepicURL:String = user.profilePicLink ?? ""
                            if(!profilepicURL.isEmpty){
                                storageRef.child("UserPictures").child(profilepicURL).getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
                                    let picture = UIImage(data: data!)
                                    self.profilePic.image = picture
                                    self.menuProfilePic.image = picture
                                }
                            }
                            self.name.text = user.firstname! + " " + user.lastname!
                            self.email.text = user.email
                            self.rating.text = user.rating?.description
                            let addy = user.address
                            self.location.text = (addy?.city)! + ", " + (addy?.state)!
                        }catch {
                            print(error)
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
    
    // function which will hide/show the menu
    func setView(view: UIScrollView, hidden: Bool) {
        UIScrollView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            view.isHidden = hidden
        })
    }
    
    // function to handle swiping left on the menu to close it
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
        let activityVC = UIActivityViewController(activityItems: ["Hello friend, check out this cool app on the app store that I am using, Tasker, the task marketplace that allows you to post errands/tasks that you need to get done so that people can take them on and work for you, or you can be the employee and take on tasks to do and get paid, download it at: https://itunes.apple.com/us/app/tasker/id361285480?mt=8"], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
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
        try! Auth.auth().signOut()
        navigateTo(newViewController: LoggedOutViewController(), transitionFrom: .fromLeft)
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
        if collectionView == self.collectionViewA{
            return skillsTasks.count
        }
        else if collectionView == self.nearByColView{
            return nearByTasks.count
        }else
        {
            return negotiableTasks.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionViewA {
        let task = skillsTasks[indexPath.row]
        let cellA = collectionView.dequeueReusableCell(withReuseIdentifier: taskCollectionViewCellId, for: indexPath) as! MyCollectionViewCell
        cellA.lbName.text = task.title
        cellA.lbCity.text = task.location?.city ?? "no city"
        cellA.lbDesc.text = task.taskDescription
        cellA.lbPrice.text = "$" + String(task.price!) + "0"
        cellA.lbCategory.text = task.category
            
        return cellA
        }
        else if collectionView == self.nearByColView{
            let task = nearByTasks[indexPath.row]
            let cellB = collectionView.dequeueReusableCell(withReuseIdentifier: taskCollectionViewCellId, for: indexPath) as! MyCollectionViewCell
            cellB.lbName.text = task.title
            cellB.lbCity.text = task.location?.city ?? "no city"
            cellB.lbDesc.text = task.taskDescription
            cellB.lbPrice.text = "$" + String(task.price!) + "0"
            cellB.lbCategory.text = task.category
            return cellB
        }
        else{
            let task = negotiableTasks[indexPath.row]
            let cellC = collectionView.dequeueReusableCell(withReuseIdentifier: taskCollectionViewCellId, for: indexPath) as! MyCollectionViewCell
            cellC.lbName.text = task.title
            cellC.lbCity.text = task.location?.city ?? "no city"
            cellC.lbDesc.text = task.taskDescription
            cellC.lbPrice.text = "$" + String(task.price!) + "0"
            cellC.lbCategory.text = task.category
            
            return cellC
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionViewA{
            let task = skillsTasks[indexPath.row]
            let showTaskVC = AcceptTaskViewController()
        DispatchQueue.main.async {
            showTaskVC.taskClientID = task.clientID!
            print("Client ID in employee task is  " + task.clientID!)
            showTaskVC.dID = task.docID!
            showTaskVC.lbTitle.text = task.title
            showTaskVC.lbLocation.text = task.location?.city ?? "no city"
            showTaskVC.lbBody.text = task.taskDescription
            showTaskVC.lbRate.text = "$" + String( task.price!) + "0"
        }
        navigateToListTaskVC(showTaskVC, .fromRight)
        }
        else if collectionView == nearByColView{
            let task = nearByTasks[indexPath.row]
            let showTaskVC = AcceptTaskViewController()
        DispatchQueue.main.async {
            showTaskVC.taskClientID = task.clientID!
            showTaskVC.dID = task.docID!
            showTaskVC.lbTitle.text = task.title
            showTaskVC.lbLocation.text = task.location?.city ?? "no city"
            showTaskVC.lbBody.text = task.taskDescription
            showTaskVC.lbRate.text = "$" + String( task.price!) + "0"
        }
        navigateToListTaskVC(showTaskVC, .fromRight)
        }
        else{
            let task = negotiableTasks[indexPath.row]
            let showTaskVC = AcceptTaskViewController()
        DispatchQueue.main.async {
            showTaskVC.taskClientID = task.clientID!
            showTaskVC.dID = task.docID!
            showTaskVC.lbTitle.text = task.title
            showTaskVC.lbLocation.text = task.location?.city ?? "no city"
            showTaskVC.lbBody.text = task.taskDescription
            showTaskVC.lbRate.text = "$" + String( task.price!) + "0"
        }
        navigateToListTaskVC(showTaskVC, .fromRight)
        }

    func navigateToListTaskVC(_ newViewController: UIViewController, _ transitionFrom:CATransitionSubtype) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.reveal
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
    
}
