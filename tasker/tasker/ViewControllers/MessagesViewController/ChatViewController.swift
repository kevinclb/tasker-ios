//
//  ChatViewController.swift
//  tasker
//
//  Created by Jeffrey Viramontes on 3/29/22.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDataSource {
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
