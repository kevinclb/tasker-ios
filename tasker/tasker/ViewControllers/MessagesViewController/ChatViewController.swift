//
//  ChatViewController.swift
//  tasker
//
//  Created by Jeffrey Viramontes on 3/29/22.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class ChatViewController: UIViewController, UITableViewDataSource {
    @IBOutlet var messageField: UITextField!
    @IBAction func sendPressed(_ sender: Any) {
        let text = messageField.text
        let newMessage = ["body": text ?? "", "sender": Utilities.getUid()]
        db.collection("conversations").document(convos.docID!).updateData(["messages": FieldValue.arrayUnion([newMessage])])
        
    }
    @IBAction func backToConversations(_ sender: Any) {
        
        let showConv = RootViewController()
        navigateTo(showConv, .fromRight)
        func navigateTo(_ newViewController: UIViewController, _ transitionFrom:CATransitionSubtype) {
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
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return convos.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatTableView.dequeueReusableCell(withIdentifier: chatCellViewId, for: indexPath) as! ChatCellTableViewCell
        if (convos.messages[indexPath.row].sender != Utilities.getUid())
        {
            cell.leftAvatar.isHidden = false
            cell.rightAvatar.isHidden = true
            cell.chatBubble.backgroundColor = .gray
            cell.chatBubble.contentMode = .scaleToFill
            cell.chatBubble.adjustsFontSizeToFitWidth = true
            cell.chatBubble.minimumScaleFactor = 0.5
            cell.chatBubble.numberOfLines = 0
            cell.chatBubble.text = convos.messages[indexPath.row].body
            print("This is the DocID in chat view controller" + convos.docID!)
        }
        else
        {
            cell.leftAvatar.isHidden = true
            cell.rightAvatar.isHidden = false
            cell.chatBubble.text = convos.messages[indexPath.row].body
        }
        
        return cell
    }
    
    var convos = Conversation()
    @IBOutlet weak var messageInput: UITextField!
    @IBOutlet weak var chatTableView: UITableView!
    
    let chatCellViewId = "ChatCellTableViewCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibCell = UINib(nibName: chatCellViewId, bundle: nil)
        chatTableView.dataSource = self
        chatTableView.register(nibCell, forCellReuseIdentifier: chatCellViewId)
        messageInput.becomeFirstResponder()
        // Do any additional setup after loading the view.
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
