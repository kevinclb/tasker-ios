//
//  Utilities.swift
//  tasker
//
//  Created by Amir Hammoud on 3/2/22.
//

// This class can be used to stylize buttons, text fields and create functions for validating textfields.
import Foundation
import UIKit
import FirebaseAuth

class Utilities {
    
    static func isEmailValid(email: String) -> Bool {
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    static func isPasswordValid(password : String) -> Bool {
        
        let passwordRegex = "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}"
        
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    static func isAgeValid(date: String) -> Bool {
        
        let dateFormatter = DateFormatter()
            
        dateFormatter.dateFormat = "MM/dd/yyyy"

        if let dateOfBirth = dateFormatter.date(from: date) {
            
            // Checking if the user is at least 18 years old
            let minimumAge: Date = Calendar.current.date(byAdding: .year, value: -18, to: Date())!;
            let maximumAge: Date = Calendar.current.date(byAdding: .year, value: -99, to: Date())!;
                
            if dateOfBirth > minimumAge {
                return false
            }
            if dateOfBirth < maximumAge {
                return false
            }
            else {
                return true
            }
        }
        else {
            return false
        }
    }
    
    static func isZipCodeValid(zipCode: String) -> Bool {
        
            let zipRegex = "^[0-9]{5}(-[0-9]{4})?$"
        
            return NSPredicate(format: "SELF MATCHES %@", zipRegex).evaluate(with: zipCode)
        }
    
    static func showError(message: String, errorLabel: UILabel) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    static func getUid() -> String {
        if let user = Auth.auth().currentUser {
            let uid = user.uid
            return uid
        } else {
            return "error: no current user signed in"
        }
    }
}


class CheckBox: UIButton {
    // Images
    let checkedImage = UIImage(systemName: "checkmark.square")! as UIImage
    let uncheckedImage = UIImage(systemName: "square")! as UIImage
    
    // Bool property
    var isChecked: Bool = false {
        didSet {
            if isChecked == true {
                self.setImage(checkedImage, for: UIControl.State.normal)
            } else {
                self.setImage(uncheckedImage, for: UIControl.State.normal)
            }
        }
    }
        
    override func awakeFromNib() {
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
        self.isChecked = false
    }
        
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}
