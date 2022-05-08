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
    var sendToID = ""
    var convo = Conversation(user1ID: "", user2ID: "", messages: [Message(body: "", sender: "")])
    var docID = ""
    var usersSorted = [""]
    var users  = [""]
    
    @IBOutlet var messageField: UITextField!
    
    @IBAction func backBTN(_ sender: Any) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = .fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        var users = [Utilities.getUid(), sendToID]
        usersSorted = users.sorted{$0.localizedCompare($1) == .orderedAscending}
<<<<<<< HEAD
        print("user 1 " + users[0] + " User 2 " + users[1])
=======
>>>>>>> main
            db.collection("conversations").whereField("user1ID", isEqualTo: usersSorted[0]).whereField("user2ID", isEqualTo: usersSorted[1]).getDocuments() { (querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    for document in querySnapshot.documents {
                        self.docID = document.documentID
                        print("Found docID = " + self.docID)
                    }
                }
            }
        // Do any additional setup after loading the view.
    }

    @IBAction func sendPressed(_ sender: Any) {
        messageToSend = messageField.text!
        if(docID == "")
        {
<<<<<<< HEAD
            convo = Conversation(user1ID: usersSorted[0], user2ID: usersSorted[1], messages: [Message(body: messageToSend, sender: Utilities.getUid())])
            do {
               print(try db.collection("conversations").addDocument(from: self.convo.self))
=======
            convo = Conversation(user1ID: users[0], user2ID: users[1], messages: [Message(body: messageToSend, sender: Utilities.getUid())])
            do {
               print(try db.collection("conversations").addDocument(from: self.convo.self))
                let backToMsgsVC = MessagesViewController()
                navigateToListTaskVC(backToMsgsVC, .fromRight)
>>>>>>> main
            }catch{
                print("Error adding document")
            }
        }
        else
        {
            let newMessage = ["body": messageToSend, "sender": Utilities.getUid()]
            db.collection("conversations").document(docID).updateData(["messages": FieldValue.arrayUnion([newMessage])])
        }
<<<<<<< HEAD
        
=======
    }
    func navigateToListTaskVC(_ newViewController: UIViewController, _ transitionFrom:CATransitionSubtype) {
>>>>>>> main
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = .fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false, completion: nil)
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
