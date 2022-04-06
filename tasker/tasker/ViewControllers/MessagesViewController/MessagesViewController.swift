//
//  MessagesViewController.swift
//  tasker
//
//  Created by Kevin Babou on 2/2/22.
//

import UIKit

class MessagesViewController: UIViewController {

    var uid = ""
    let messageCollectionViewCellId = "MessageViewCell"
    
    @IBOutlet var messageViewCollection: UICollectionView!
    @IBAction func newMessage(_ sender: Any) {
        
        let newMsgVC = NewMessageViewController()
        navigateToListTaskVC(newMsgVC, .fromRight)
    }
    
    var messages = [Message]()
    override func viewDidLoad() {
        super.viewDidLoad()
        uid = Utilities.getUid()
        let nibCell = UINib(nibName: messageCollectionViewCellId, bundle: nil)
        messageViewCollection.register(nibCell, forCellWithReuseIdentifier: messageCollectionViewCellId)
        messageViewCollection.delegate = self
        messageViewCollection.dataSource = self
        messageViewCollection.awakeFromNib()
        
        for i in 1...35{
            var message1 = Message(body: "Message will go here", sender:User.init())
            messages.append(message1)
        }
        
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
}
    
extension MessagesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 35
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: messageCollectionViewCellId, for: indexPath) as! MessageViewCell
        let message = messages[indexPath.row]
        cell.lbName.text = message.sender.firstname
        cell.lbMessage.text = message.body
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}

