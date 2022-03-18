//
//  Utilities.swift
//  tasker
//
//  Created by Amir Hammoud on 3/2/22.
//

// This class can be used to stylize buttons, text fields and create functions for validating textfields.
import Foundation
import UIKit

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
                
            if dateOfBirth > minimumAge {
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
}
