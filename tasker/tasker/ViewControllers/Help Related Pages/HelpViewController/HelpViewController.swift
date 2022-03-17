//
//  HelpViewController.swift
//  tasker
//
//  Created by User on 2/28/22.
//

import UIKit

class HelpViewController: UIViewController {

    // IBOutlets for the answer labels
    @IBOutlet weak var abtAppAns: UILabel!
    @IBOutlet weak var hackedAns: UILabel!
    @IBOutlet weak var pmntRcvdAns: UILabel!
    @IBOutlet weak var contactClientAns: UILabel!
    @IBOutlet weak var cancelTaskAns: UILabel!
    @IBOutlet weak var aboutTeamAns: UILabel!
    @IBOutlet weak var supportDevAns: UILabel!
    
    // Boolean variables for the questions clicked or not
    var abtApp = false, hackedBool = false, pmntRcvdBool = false, contactClientBool = false, cancelTaskBool = false, aboutTeamBool = false, supportDevBool = false
    
    // String variables for answers for questions
    var abtAnswer = "Started by a group of students in our last semester in college for our computer science senior project class, Tasker is an application that helps you find tasks near you in your city to take on and complete then be compensated by the client that posted the task, or you can be the client and post tasks for people to do for you!"
    var hackedAnswer = "If you believe that your password has been compromised or that your account got hacked, then you can change your password by heading to the settings page after navigating back to the homepage by pressing the back arrow, then from the slide out hamburger menu\nClick on the settings icon -> then click on account settings"
    var pmntRcvdAnswer = "Please check your paypal account and make sure it is fully working and that paypal is not having any issues outside of our control, then check to make sure that you have completed the task entirely with all of its requirements, if everything seems good so far, try reaching out and asking the client if they have sent the payment yet, if all else fails please reach out to us using the contact us feature in the hamburger menu on your homepage or employee homepage, thank you!"
    var contactClientAnswer = "If you are unable to contact your client for any reason, please reach out to us using the contact us feature in the hamburger menu on your homepage or employee homepage, we recommend that you exchange contact info with your client and aside from messaging them on Tasker if you are both comfortable with that in order to avoid any delays in responses and in order to have another method of communication."
    var cancelTaskAnswer = "If you would like to cancel a task that you have already started on, please reach out to the client and come to an agreement, then reach out to us using the contact us button on the slide out menu."
    var aboutTeamAnswer = "The development team consists of four computer science graduates and this project was made for our senior project class which is a two semester class aiming at putting our skills and learning abilities as a team to work."
    var supportDevAnswer = "You can support development by sharing this app to your friends and people you know by using the refer a friend button found on the slide out menu, we appreciate your passion to support us and thank you in advance!"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func abtAppTapped(_ sender: UIButton) {
        if(!abtApp){
            abtAppAns.text = abtAnswer
            abtAppAns.lineBreakMode = .byWordWrapping
            abtApp = true
            sender.setTitle("-    About the Tasker app", for: .normal)
        }
        else{
            abtAppAns.text = " "
            abtAppAns.lineBreakMode =  .byTruncatingTail
            abtApp = false
            sender.setTitle("+    About the Tasker app", for: .normal)
        }
        abtAppAns.numberOfLines = 0
    }
    
    @IBAction func hackedTapped(_ sender: UIButton) {
        if(!hackedBool){
            hackedAns.text = hackedAnswer
            hackedAns.lineBreakMode = .byWordWrapping
            hackedBool = true
            sender.setTitle("-    I believe that my account got hacked, what should I do?", for: .normal)
        }
        else{
            hackedAns.text = " "
            hackedAns.lineBreakMode =  .byTruncatingTail
            hackedBool = false
            sender.setTitle("+    I believe that my account got hacked, what should I do?", for: .normal)
        }
        hackedAns.numberOfLines = 0
    }
    
    @IBAction func pmntRcvdTapped(_ sender: UIButton) {
        if(!pmntRcvdBool){
            pmntRcvdAns.text = pmntRcvdAnswer
            pmntRcvdAns.lineBreakMode = .byWordWrapping
            pmntRcvdBool = true
            sender.setTitle("-    I have not received my payment", for: .normal)
        }
        else{
            pmntRcvdAns.text = " "
            pmntRcvdAns.lineBreakMode =  .byTruncatingTail
            pmntRcvdBool = false
            sender.setTitle("+    I have not received my payment", for: .normal)
        }
        pmntRcvdAns.numberOfLines = 0
    }
    
    @IBAction func contactClientTapped(_ sender: UIButton) {
        if(!contactClientBool){
            contactClientAns.text = contactClientAnswer
            contactClientAns.lineBreakMode = .byWordWrapping
            contactClientBool = true
            sender.setTitle("-    Unable to contact my client", for: .normal)
        }
        else{
            contactClientAns.text = " "
            contactClientAns.lineBreakMode =  .byTruncatingTail
            contactClientBool = false
            sender.setTitle("+    Unable to contact my client", for: .normal)
        }
        contactClientAns.numberOfLines = 0
    }
    
    @IBAction func cancelTaskTapped(_ sender: UIButton) {
        if(!cancelTaskBool){
            cancelTaskAns.text = cancelTaskAnswer
            cancelTaskAns.lineBreakMode = .byWordWrapping
            cancelTaskBool = true
            sender.setTitle("-    I want to cancel a task I already started on", for: .normal)
        }
        else{
            cancelTaskAns.text = " "
            cancelTaskAns.lineBreakMode =  .byTruncatingTail
            cancelTaskBool = false
            sender.setTitle("+    I want to cancel a task I already started on", for: .normal)
        }
        pmntRcvdAns.numberOfLines = 0
    }
    
    @IBAction func aboutTeamTapped(_ sender: UIButton) {
        if(!aboutTeamBool){
            aboutTeamAns.text = aboutTeamAnswer
            aboutTeamAns.lineBreakMode = .byWordWrapping
            aboutTeamBool = true
            sender.setTitle("-    About the development team", for: .normal)
        }
        else{
            aboutTeamAns.text = " "
            aboutTeamAns.lineBreakMode =  .byTruncatingTail
            aboutTeamBool = false
            sender.setTitle("+    About the development team", for: .normal)
        }
        pmntRcvdAns.numberOfLines = 0
    }
    
    @IBAction func supportDevTapped(_ sender: UIButton) {
        if(!supportDevBool){
            supportDevAns.text = supportDevAnswer
            supportDevAns.lineBreakMode = .byWordWrapping
            supportDevBool = true
            sender.setTitle("-    How can I support development?", for: .normal)
        }
        else{
            supportDevAns.text = " "
            supportDevAns.lineBreakMode =  .byTruncatingTail
            supportDevBool = false
            sender.setTitle("+    How can I support development?", for: .normal)
        }
        pmntRcvdAns.numberOfLines = 0
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
