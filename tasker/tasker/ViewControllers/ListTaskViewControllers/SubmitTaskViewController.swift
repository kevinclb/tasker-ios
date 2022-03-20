//
//  SubmitTaskViewController.swift
//  tasker
//
//  Created by Kevin Babou on 3/20/22.
//

import UIKit
import MapKit
import CoreLocation

class SubmitTaskViewController: UIViewController, CLLocationManagerDelegate {
    
    var task: Errand!
    private var currentLocation: CLLocation!
    var geocoder = CLGeocoder()
    @IBOutlet weak var priceTextField: UITextField!
    @IBAction func postTaskButtonPressed(_ sender: UIButton) {
        print("post task button pressed")
        
        //MARK: location manager code
        DispatchQueue.main.async {
            do {
                print("docRef:", try db.collection("tasks").addDocument(from: self.task!))
            } catch {
                print("error adding document")
            }
        }
        
    }
    
    @IBOutlet weak var mkMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
//        mkMapView.showsUserLocation = true
        
        task.price = 100
        task.negotiable = true
//        geocoder.reverseGeocodeLocation(currentLocation) { placemarks, error in
//            if let error = error {
//                print("error reverse geocoding location: ", error.localizedDescription)
//            }
//
//            guard let placemark = placemarks?.first else { print("no placemarks found"); return }
//            print("placemark: ", placemark)
//            self.task.location?.city = placemark.locality
//            self.task.location?.state = placemark.administrativeArea
//            self.task.location?.zipcode = Int(placemark.postalCode!)
//        }
        
        print("location from submitTask")
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
            self.task.location?.city = placemark.locality
            self.task.location?.state = placemark.administrativeArea
            self.task.location?.zipcode = Int(placemark.postalCode!)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("locationManager \(error.localizedDescription)")
    }
}
