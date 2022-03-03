//
//  FAQViewController.swift
//  tasker
//
//  Created by User on 3/1/22.
//

import UIKit

class FAQViewController: UIViewController {
    
    // IBOutlets for the answer labels
    @IBOutlet weak var whatsTasker: UILabel!
    @IBOutlet weak var whoCanSignup: UILabel!
    
    // Boolean variables for the questions clicked or not
    var whtTskr = false,whoCanBool = false
    
    
    // String variables for answers for questions
    var taskerAns = "Tasker is an application that helps you find tasks near you in your city to take on and complete then be compensated directly by the client that posted the task, it is also for those that want to get things done around their house, business, backyard, garage, etc. but do not have the time to do so and would rather just make a listing and pay someone else to run their errands or do the task for them when they are busy."
    var whoSignupAns = "Anyone can sign up to be a tasker, click on the slide out menu option to refer a friend and tell your friends about us, when you sign up for an account, Tasker automatically creates a client as well as an employee account for you, so not only those looking for work can join but also those that need work done for them as well!"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }


    @IBAction func whatsTaskerClicked(_ sender: UIButton) {
        if(!whtTskr){
            whatsTasker.text = taskerAns
            whatsTasker.lineBreakMode = .byWordWrapping
            whtTskr = true
            sender.setTitle("- What is Tasker?", for: .normal)
            
        }
        else{
            whatsTasker.text = " "
            whatsTasker.lineBreakMode =  .byTruncatingTail
            whtTskr = false
            sender.setTitle("+ What is Tasker?", for: .normal)
        }
        
    }
    @IBAction func whoCnSignupClicked(_ sender: UIButton) {
        if(!whoCanBool){
            whoCanSignup.text = taskerAns
            whoCanSignup.lineBreakMode = .byWordWrapping
            whoCanBool = true
            sender.setTitle("- Who can sign up to be a tasker?", for: .normal)
        }
        else{
            whoCanSignup.text = " "
            whoCanSignup.lineBreakMode =  .byTruncatingTail
            whoCanBool = false
            sender.setTitle("+ Who can sign up to be a tasker?", for: .normal)
        }
    }
    

}
