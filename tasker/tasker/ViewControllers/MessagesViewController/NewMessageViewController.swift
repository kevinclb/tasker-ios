//
//  NewMessageViewController.swift
//  tasker
//
//  Created by Jeffrey Viramontes on 3/31/22.
//

import UIKit
import Firebase

class NewMessageViewController: UIViewController {
    
    var messageToSend = ""
    var convo = Conversation(user1ID: "", user2ID: "", messages: [Message(body: "", sender: "")])
    @IBOutlet var messageField: UITextField!
    
    @IBAction func backBTN(_ sender: Any) {
        let backToMsgsVC = MessagesViewController()
        navigateToListTaskVC(backToMsgsVC, .fromRight)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func sendPressed(_ sender: Any) {
        messageToSend = messageField.text!
        convo = Conversation(user1ID: Utilities.getUid(), user2ID: "", messages: [Message(body: messageToSend, sender: Utilities.getUid())])
        do {
           print(try db.collection("conversations").addDocument(from: self.convo.self))
            let backToMsgsVC = MessagesViewController()
            navigateToListTaskVC(backToMsgsVC, .fromRight)
        }catch{
            print("Error adding document")
        }
        print(messageToSend)

        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
