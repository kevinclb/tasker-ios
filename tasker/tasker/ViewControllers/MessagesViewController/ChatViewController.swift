//
//  ChatViewController.swift
//  tasker
//
//  Created by Jeffrey Viramontes on 3/29/22.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDataSource {
    @IBAction func backToConversations(_ sender: Any) {
        
        let showConv = MessagesViewController()
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatTableView.dequeueReusableCell(withIdentifier: chatCellViewId, for: indexPath) as! ChatCellTableViewCell
        if (indexPath.row % 2 == 0)
        {
            cell.leftAvatar.isHidden = false
            cell.rightAvatar.isHidden = true
            cell.chatBubble.alignmentRect(forFrame: CGRect(x:10, y:5, width:80, height:9 ))
            cell.chatBubble.backgroundColor = .gray
        }
        else
        {
            cell.leftAvatar.isHidden = true
            cell.rightAvatar.isHidden = false
            
        }
        
        return cell
    }
    

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
