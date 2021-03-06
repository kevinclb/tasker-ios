//
//  HomeExplorePageViewController.swift
//  tasker
//
//  Created by Kevin Babou on 2/2/22.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseStorage
import CoreLocation


//TODO: Make the home page more pretty.
//TODO: Add different sections
class HomeExplorePageViewController: UIViewController {
    private var userCollectionRef: CollectionReference!
    private var nearbyTaskers = [User]()
    private var userLocation = Address()
    private var locationString: String!
    private var currentLocation: CLLocation!
    
    
    var geocoder = CLGeocoder()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var HomePageCollectionView: UICollectionView!
    
    let taskerCollectionViewCellId = "TaskerCollectionViewCell"
    
    // Outlets for the menu for animation purposes
    @IBOutlet weak var menuScroll: UIScrollView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var menuLeading: NSLayoutConstraint!
    @IBOutlet weak var menuTrailing: NSLayoutConstraint!
    
    // Outlet for employee profile button
    @IBOutlet weak var employeeProfileButton: UIButton!
    
    // Outlets for profile pictures
    @IBOutlet weak var menuProfilePic: UIImageView!
    @IBOutlet weak var profPic: UIImageView!
    
    // Menu outlets for setting name, rating, etc.
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var cityAndState: UILabel!
    @IBOutlet weak var email: UILabel!
    

    
    var menuOut = false
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: searchBar initialization
        searchBar.showsSearchResultsButton = true
        searchBar.placeholder = "Search for taskers here"
        
        //MARK: menu scroll code
        menuScroll.bounces = false
        menuScroll.showsVerticalScrollIndicator = false
        menuScroll.showsHorizontalScrollIndicator = false
        
        
        // for profile pictures, the one on the menu and the one on the main page
        // We want to show them rounded instead of rectangle
        self.profPic.layer.borderWidth = 1.0
        self.profPic.layer.masksToBounds = false
        self.profPic.layer.borderColor = UIColor.white.cgColor
        self.profPic.layer.cornerRadius = self.profPic.frame.size.width / 2
        self.profPic.clipsToBounds = true
        self.menuProfilePic.layer.borderWidth = 1.0
        self.menuProfilePic.layer.masksToBounds = false
        self.menuProfilePic.layer.borderColor = UIColor.white.cgColor
        self.menuProfilePic.layer.cornerRadius = self.profPic.frame.size.width / 2
        self.menuProfilePic.clipsToBounds = true

        
        //MARK: collection view code
        let nibCell = UINib(nibName: taskerCollectionViewCellId, bundle: nil)
        HomePageCollectionView.register(nibCell, forCellWithReuseIdentifier: taskerCollectionViewCellId)
        HomePageCollectionView.delegate = self
        HomePageCollectionView.dataSource = self
        TaskerCollectionViewCell.awakeFromNib()
        
        //MARK: searchbar delegate
        searchBar.delegate = self
        
        //MARK: swipe gesture recognizer to handle closing the menu when user swipes left on it
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        leftSwipe.direction = .left
        view.addGestureRecognizer(leftSwipe)
        
        self.hideKeyboardWhenTappedAround()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //MARK: location manager code
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        //MARK: check if user is an employee or not, if they didn't make an employee account, then hide the employee profile button from menu, load their picture and info as well
        let databas = Firestore.firestore()
        guard let userID = Auth.auth().currentUser?.uid else {return}
        let docReff = databas.collection("users").document(userID)
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
                                    self.profPic.layer.borderWidth = 1.0
                                    self.profPic.layer.masksToBounds = false
                                    self.profPic.layer.borderColor = UIColor.white.cgColor
                                    self.profPic.layer.cornerRadius = self.profPic.frame.size.width / 2
                                    self.profPic.clipsToBounds = true
                                    self.profPic.image = picture
                                    self.menuProfilePic.image = picture
                                }
                            }
                            let employOrNot = user.employee ?? false
                            // User is employee so make the button visible, otherwise hide it
                            if(employOrNot){
                                self.employeeProfileButton.isHidden = false
                            }
                            else{
                                self.employeeProfileButton.isHidden = true
                            }
                            self.name.text = user.firstname! + " " + user.lastname!
                            self.email.text = user.email
                            let addy = user.address
                            self.cityAndState.text = (addy?.city)! + ", " + (addy?.state)!
                        }catch {
                            print(error)
                        }
                    }
        }
        
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
                    setView(view: menuScroll, hidden: true)
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
    
    @IBAction func referAFriendTapped(_ sender: Any) {
        let activityVC = UIActivityViewController(activityItems: ["Hello friend, check out this cool app on the app store that I am using, Tasker, the task marketplace that allows you to post errands/tasks that you need to get done so that people can take them on and work for you, or you can be the employee and take on tasks to do and get paid, download it at: https://itunes.apple.com/us/app/tasker/id361285480?mt=8"], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func FAQTapped(_ sender: Any) {
        navigateTo(newViewController: FAQViewController(), transitionFrom: .fromRight)
    }
    
    @IBAction func contactUsTapped(_ sender: Any) {
        navigateTo(newViewController: ContactUsViewController(), transitionFrom: .fromRight)
    }
    
    @IBAction func aboutUsTapped(_ sender: Any) {
        navigateTo(newViewController: AboutUsViewController(), transitionFrom: .fromRight)
    }
    
    @IBAction func recentTasksTapped(_ sender: Any) {
        navigateTo(newViewController: RecentTasksRootVC(), transitionFrom: .fromRight)
    }
    
    @IBAction func employeeProfileTapped(_ sender: Any) {
        navigateTo(newViewController: EmployeeRootViewController(), transitionFrom: .fromRight)
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
        setView(view: menuScroll, hidden: true)
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

//MARK: Navigating to ListTaskVC
extension HomeExplorePageViewController {
    @IBAction func listTaskButtonPressed(_ sender: UIButton) {
        navigateToListTaskVC(ListTaskViewController(), .fromRight)
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

extension HomeExplorePageViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nearbyTaskers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: taskerCollectionViewCellId, for: indexPath) as! TaskerCollectionViewCell
        let tasker = nearbyTaskers[indexPath.row]
        cell.taskerName.text = tasker.firstname
        cell.taskerCity.text = tasker.city
        cell.taskerRating.text = String(tasker.rating!)
        cell.taskerDescription.text = tasker.employeeDescription
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tasker = nearbyTaskers[indexPath.row]
        print("\(indexPath.row) - \(tasker.firstname ?? "no first name error")")
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
    
}

extension HomeExplorePageViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.placeholder = ""
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("text did change")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            print("nothing searched, no results")
            return
        }
        
        let searchVC = SearchResultsTableViewController(nibName: "SearchResultsTableViewController", bundle: nil)
        searchVC.searchQuery = searchBar.text!
        navigateToResults(newViewController: searchVC, transitionFrom: .fromTop)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if (searchBar.text?.isEmpty)! {
            searchBar.placeholder = "Search for taskers here"
        }
    }
    
}


//MARK: - CLLocationManagerDelegate

extension HomeExplorePageViewController: CLLocationManagerDelegate {
    fileprivate func fetchAndLoadNearbyTaskers() {
        let collectionRef = db.collection("users")
        collectionRef.whereField("address.zipcode", isGreaterThan: self.userLocation.zipcode!-10000).whereField("address.zipcode", isLessThan: self.userLocation.zipcode!+10000).getDocuments { snapshot, error in
            if let error = error {
                print("error: \(error.localizedDescription)")
            } else {
                print("loading snapshot successful")
                guard let snapshot = snapshot else { return }
                for document in snapshot.documents {
                    do {
                        try self.nearbyTaskers.append(document.data(as: User.self)!)
                    } catch {
                        print("error decoding taskers to HomePageVC taskers array")
                    }
                }
                if self.nearbyTaskers.count == snapshot.documents.count {
                    print("random tasker data: ", String(describing: self.nearbyTaskers[Int(self.nearbyTaskers.count-1)].firstname))
                    print("success loading taskers")
                } else {
                    print("error loading taskers")
                    print("taskers in self.nearbyTaskers: ", self.nearbyTaskers.count)
                    print("taskers in snapshot documents: ", snapshot.documents.count)
                }
            }
            print("nearby taskers count after fetch: ", self.nearbyTaskers.count)
            self.HomePageCollectionView.reloadData()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = manager.location
        geocoder.reverseGeocodeLocation(currentLocation) { placemarks, error in
            if let error = error {
                print("error reverse geocoding location: ", error.localizedDescription)
            }
            
            guard let placemark = placemarks?.first else { print("no placemarks found"); return }
            print("placemark: ", placemark)
            self.userLocation.city = placemark.locality
            self.userLocation.state = placemark.administrativeArea
            self.userLocation.zipcode = Int(placemark.postalCode!)
            
            DispatchQueue.main.async { //comment this out to save us money on reads.
                self.fetchAndLoadNearbyTaskers()
            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("locationManager \(error.localizedDescription)")
    }
    
    func navigateToResults(newViewController:UIViewController, transitionFrom:CATransitionSubtype){
            // this code here is to present from right to left instead of bottom to top
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = CATransitionType.moveIn
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
