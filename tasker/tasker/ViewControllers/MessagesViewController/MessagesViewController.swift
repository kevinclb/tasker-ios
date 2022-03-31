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
}

