//
//  ChatCellTableViewCell.swift
//  tasker
//
//  Created by Jeffrey Viramontes on 3/29/22.
//

import UIKit

class ChatCellTableViewCell: UITableViewCell {

    @IBOutlet weak var chatBubble: UILabel!
    @IBOutlet weak var leftAvatar: UIImageView!
    @IBOutlet weak var rightAvatar: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        chatBubble.layer.cornerRadius = 8
        chatBubble.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
