//
//  MessagesViewController.swift
//  tasker
//
//  Created by Kevin Babou on 2/2/22.
//

import UIKit

class MessagesViewController: UIViewController {

    let messageCollectionViewCellId = "MessageViewCell"
    
    @IBOutlet var messageViewCollection: UICollectionView!
    
    var messages = [message]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibCell = UINib(nibName: messageCollectionViewCellId, bundle: nil)
        messageViewCollection.register(nibCell, forCellWithReuseIdentifier: messageCollectionViewCellId)
        messageViewCollection.delegate = self
        messageViewCollection.dataSource = self
        messageViewCollection.awakeFromNib()
        
        for i in 1...35{
            var message1 = message()
            message1.name = "Tom "
            message1.message = "Message information will go here and populate from database"
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
        cell.lbName.text = message.name!
        cell.lbMessage.text = message.message!
        return cell
    }
}

