//
//  RecentTaskTableViewCell.swift
//  tasker
//
//  Created by Kevin Babou on 4/5/22.
//

import UIKit

protocol RecentTaskTableViewCellDelegate {
    func didRateButtonPressed()
}

class RecentTaskTableViewCell: UITableViewCell {
    
    var delegate: RecentTaskTableViewCellDelegate?

    @IBOutlet weak var taskerNameLabel: UILabel!
    
    @IBOutlet weak var taskNameLabel: UILabel!

    @IBAction func rateButton(_ sender: UIButton) {
        delegate?.didRateButtonPressed()
        
    }
    
    
    @IBAction func payButton(_ sender: UIButton) {
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
