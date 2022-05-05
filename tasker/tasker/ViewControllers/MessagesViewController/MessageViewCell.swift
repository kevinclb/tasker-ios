//
//  MessageViewCell.swift
//  tasker
//
//  Created by Jeffrey Viramontes on 2/22/22.
//

import UIKit

class MessageViewCell: UICollectionViewCell {

    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbMessage: UILabel!
    @IBOutlet var avatar: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
