//
//  HelpViewController.swift
//  tasker
//
//  Created by User on 2/28/22.
//

import UIKit

class HelpViewController: UIViewController {

    @IBOutlet weak var abtAppAns: UILabel!
    
    // Boolean variables for the questions clicked or not
    var abtApp = false
    
    // String variables for answers for questions
    var abtAnswer = "Started by a group of students in our last semester in college for our computer science senior project class, Tasker is an application that helps you find tasks near you in your city to take on and complete then be compensated by the client that posted the task, or you can be the client and post tasks for people to do for you!"
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func abtAppTapped(_ sender: Any) {
        if(!abtApp){
            abtAppAns.text = abtAnswer
            abtAppAns.lineBreakMode = .byWordWrapping
            abtApp = true
        }
        else{
            abtAppAns.text = " "
            abtAppAns.lineBreakMode =  .byTruncatingTail
            abtApp = false
        }
    }
    
}
