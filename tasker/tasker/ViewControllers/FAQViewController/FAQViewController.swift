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
    @IBOutlet weak var whenPayment: UILabel!
    @IBOutlet weak var clientIssues: UILabel!
    @IBOutlet weak var updateInfo: UILabel!
    @IBOutlet weak var forgotPass: UILabel!
    @IBOutlet weak var cantComplete: UILabel!
    
    // Boolean variables for the questions clicked or not
    var whtTskr = false,whoCanBool = false,whenPaymentBool = false, clientIssuesBool = false, updateInfoBool = false, forgotPassBool = false, cantCompleteBool = false
    
    // String variables for answers for questions
    var taskerAns = "Tasker is an application that helps you find tasks near you in your city to take on and complete then be compensated directly by the client that posted the task, it is also for those that want to get things done around their house, business, backyard, garage, etc. but do not have the time to do so and would rather just make a listing and pay someone else to run their errands or do the task for them when they are busy."
    var whoSignupAns = "Anyone can sign up to be a tasker, click on the slide out menu option to refer a friend and tell your friends about us, when you sign up for an account, Tasker automatically creates a client as well as an employee account for you, so not only those looking for work can join but also those that need work done for them as well!"
    var whenPaymentAns = "Your payment will be processed after finishing the task with all of the requirements and then the payment will be sent to your paypal."
    var clientIssuesAns = "Tasker and the development team are not responsible for any issues between the client and the employee, please try to contact your client and for further issues or concerns, please reach out to us via the contact us button on the slide out menu or settings page."
    var updateInfoAns = "On the settings page, there is an option to edit profile information, that is where you can update your profile information. For updating payment information, you can click on the edit payment information button on the settings page. For modifying notification settings, you can click on the app notifications button on the settings page."
    var forgotPassAns = "If you forgot your password, you can reset it by going to the settings page then clicking on edit account information button."
    var cantCompleteAns = "If you have accepted a task that you cannot complete anymore, please contact us and the client first letting us know! We hope everything is going well!"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }


    @IBAction func whatsTaskerClicked(_ sender: UIButton) {
        if(!whtTskr){
            whatsTasker.text = taskerAns
            whatsTasker.lineBreakMode = .byWordWrapping
            whtTskr = true
            sender.setTitle("-    What is Tasker?", for: .normal)
            
        }
        else{
            whatsTasker.text = " "
            whatsTasker.lineBreakMode =  .byTruncatingTail
            whtTskr = false
            sender.setTitle("+    What is Tasker?", for: .normal)
        }
        
    }
    @IBAction func whoCnSignupClicked(_ sender: UIButton) {
        if(!whoCanBool){
            whoCanSignup.text = taskerAns
            whoCanSignup.lineBreakMode = .byWordWrapping
            whoCanBool = true
            sender.setTitle("-    Who can sign up to be a tasker?", for: .normal)
        }
        else{
            whoCanSignup.text = " "
            whoCanSignup.lineBreakMode =  .byTruncatingTail
            whoCanBool = false
            sender.setTitle("+    Who can sign up to be a tasker?", for: .normal)
        }
    }
    
    @IBAction func whenPaymentClicked(_ sender: UIButton) {
        if(!whenPaymentBool){
            whenPayment.text = whenPaymentAns
            whenPayment.lineBreakMode = .byWordWrapping
            whenPaymentBool = true
            sender.setTitle("-    When will my payment be processed?", for: .normal)
        }
        else{
            whenPayment.text = " "
            whenPayment.lineBreakMode =  .byTruncatingTail
            whenPaymentBool = false
            sender.setTitle("+    When will my payment be processed?", for: .normal)
        }
    }
    
    @IBAction func clientIssuesClicked(_ sender: UIButton) {
        if(!clientIssuesBool){
            clientIssues.text = clientIssuesAns
            clientIssues.lineBreakMode = .byWordWrapping
            clientIssuesBool = true
            sender.setTitle("-    Who is responsible for any issues between me and client?", for: .normal)
        }
        else{
            clientIssues.text = " "
            clientIssues.lineBreakMode =  .byTruncatingTail
            clientIssuesBool = false
            sender.setTitle("+    Who is responsible for any issues between me and client?", for: .normal)
        }
    }
    
    
    @IBAction func updateInfoClicked(_ sender: UIButton) {
        if(!updateInfoBool){
            updateInfo.text = updateInfoAns
            updateInfo.lineBreakMode = .byWordWrapping
            updateInfoBool = true
            sender.setTitle("-    How can I update my information?", for: .normal)
        }
        else{
            updateInfo.text = " "
            updateInfo.lineBreakMode =  .byTruncatingTail
            updateInfoBool = false
            sender.setTitle("+    How can I update my information?", for: .normal)
        }
    }
    
    @IBAction func forgotPassClicked(_ sender: UIButton) {
        if(!forgotPassBool){
            forgotPass.text = forgotPassAns
            forgotPass.lineBreakMode = .byWordWrapping
            forgotPassBool = true
            sender.setTitle("-    I forgot my password, what can I do?", for: .normal)
        }
        else{
            forgotPass.text = " "
            forgotPass.lineBreakMode =  .byTruncatingTail
            forgotPassBool = false
            sender.setTitle("+    I forgot my password, what can I do?", for: .normal)
        }
    }
    @IBAction func cantCompleteClicked(_ sender: UIButton) {
        if(!cantCompleteBool){
            cantComplete.text = cantCompleteAns
            cantComplete.lineBreakMode = .byWordWrapping
            cantCompleteBool = true
            sender.setTitle("-    I took on a task but found out I can’t complete it anymore", for: .normal)
        }
        else{
            cantComplete.text = " "
            cantComplete.lineBreakMode =  .byTruncatingTail
            cantCompleteBool = false
            sender.setTitle("+    I took on a task but found out I can’t complete it anymore", for: .normal)
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        // this code here is to present from right to left instead of bottom to top
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = .fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false, completion: nil)
    }
}
