//
//  SubmitTaskViewController.swift
//  tasker
//
//  Created by Kevin Babou on 3/20/22.
//

import UIKit
import MapKit
import CoreLocation

//TODO: Safeguard against errors when checking the input fields.

class SubmitTaskViewController: UIViewController, CLLocationManagerDelegate {
    
    var task: Errand!
    private var currentLocation: CLLocation!
    var geocoder = CLGeocoder()
    var locationChecked = false
    var negotiableChecked = false
    var validPrice = false
    var cost: Double!
    var taskLocation = Address()
    let locationManager = CLLocationManager()
    @IBOutlet weak var errorLabel: UILabel!
    
    
    @IBOutlet weak var priceTextField: UITextField!
    
    
    
    @IBOutlet weak var mkMapView: MKMapView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        
        
        locationManager.delegate = self
        
        
        mkMapView.showsUserLocation = true
        
        
        print("location from submitTask")
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    convenience init(inputTask: Errand) {
        self.init(nibName: nil, bundle: nil)
        self.task = inputTask
        
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

extension SubmitTaskViewController {
    @IBAction func textFieldEndedEditing(_ sender: UITextField) {
        if let cost = Double(priceTextField.text!) {
            if (Double(priceTextField.text!)! < 1000000.0) {
                print("The user entered a value price of \(cost)")
                self.validPrice = true
                self.cost = Double(priceTextField.text!)!
            }
            
        } else {
            self.validPrice = false
            print("Not a valid number: \(priceTextField.text!)")
        }
    }
}

//TODO: add logic to take MapKit's dropped pin if checkbox not checked.

//MARK: if checkboxes get checked
extension SubmitTaskViewController {
    @IBAction func currentLocationTextChecked(_ sender: CheckBox) {
        self.locationChecked = !self.locationChecked
        
        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.requestLocation()
    }
    
    @IBAction func negotiableTextChecked(_ sender: CheckBox) {
        self.negotiableChecked = !self.negotiableChecked
    }
}


//MARK: post task button pressed
extension SubmitTaskViewController {
    @IBAction func postTaskButtonPressed(_ sender: UIButton) {
        if self.validPrice {
            task.price = self.cost
            task.negotiable = self.negotiableChecked
            task.location = self.taskLocation
            task.listingDate = Date.now
            
            print("post task button pressed")
            do {
                print("docRef:", try db.collection("tasks").addDocument(from: self.task.self!))
                errorLabel.textColor = .systemGreen
                errorLabel.text = "Task posted successfully! (segue back)"
                //TODO: add segue back to home page view controller.
            } catch {
                print("error adding document")
            }
        }
        else {
            errorLabel.text = "Please enter a valid dollar amount."
        }
    }
}


//MARK: back button pressed

extension SubmitTaskViewController {
    @IBAction func backButtonPressed(_ sender: UIButton) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = manager.location
        geocoder.reverseGeocodeLocation(currentLocation) { placemarks, error in
            if let error = error {
                print("error reverse geocoding location: ", error.localizedDescription)
            }
            guard let placemark = placemarks?.first else { print("no placemarks found"); return }
            print("placemark: ", placemark)
            self.taskLocation.city = placemark.locality
            self.taskLocation.state = placemark.administrativeArea
            self.taskLocation.zipcode = Int(placemark.postalCode!)
            self.taskLocation.country = placemark.country
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("locationManager \(error.localizedDescription)")
    }
    
}
