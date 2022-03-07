//
//  TaskerCollectionViewCell.swift
//  tasker
//
//  Created by Kevin Babou on 2/28/22.
//

import UIKit

class TaskerCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var taskerName: UILabel!
    @IBOutlet weak var taskerCity: UILabel!
    @IBOutlet weak var taskerDescription: UILabel!
    @IBOutlet weak var taskerRating: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.contentView.layer.masksToBounds = true
        self.contentView.layer.cornerRadius = 10.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.black.cgColor
    }

}
