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
        
        // Initialization code
    }

}
