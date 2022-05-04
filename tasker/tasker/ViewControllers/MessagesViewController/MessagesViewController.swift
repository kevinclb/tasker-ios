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
    
    var conversations = [Conversation]()
    override func viewDidLoad() {
        super.viewDidLoad()
        uid = Utilities.getUid()
        let nibCell = UINib(nibName: messageCollectionViewCellId, bundle: nil)
        messageViewCollection.register(nibCell, forCellWithReuseIdentifier: messageCollectionViewCellId)
        messageViewCollection.delegate = self
        messageViewCollection.dataSource = self
        messageViewCollection.awakeFromNib()
        
        let convRef = db.collection("conversations")
        convRef.whereField("user1ID", isEqualTo: uid).getDocuments { (snapshot, error) in
            if error != nil {
                print("error retrieving conversation documents: \(String(describing: error?.localizedDescription))")
            } else {
                for d in (snapshot!.documents) {
                    do {
                        try self.conversations.append(d.data(as: Conversation.self)!)
                    } catch {
                        print("error decoding conversation(errand) document")
                    }
                }
//                DispatchQueue.main.async {
//                    self.messageViewCollection.reloadData()
//                }
            }
        }
        
        convRef.whereField("user2ID", isEqualTo: uid).getDocuments { (snapshot, error) in
            if error != nil {
                print("error retrieving conversation documents: \(String(describing: error?.localizedDescription))")
            } else {
                for d in (snapshot!.documents) {
                    do {
                        try self.conversations.append(d.data(as: Conversation.self)!)
                    } catch {
                        print("error decoding conversation(errand) document")
                    }
                }
                DispatchQueue.main.async {
                    self.messageViewCollection.reloadData()
                }
            }
        }
        self.messageViewCollection.reloadData()
        
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
        return conversations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: messageCollectionViewCellId, for: indexPath) as! MessageViewCell
        let convo = conversations[indexPath.row]
        let lastMessageCount = convo.messages.count
        cell.lbName.text = "Name will go here"
        cell.lbMessage.text = convo.messages[lastMessageCount-1].body
        print("document ID is" + convo.docID!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        let showChatVC = ChatViewController()
        DispatchQueue.main.async {
            showChatVC.convos = self.conversations[indexPath.row]
        }
        navigateTo(showChatVC, .fromRight)
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
}

