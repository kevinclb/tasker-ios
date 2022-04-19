//
//  RecentTaskTableViewCell.swift
//  tasker
//
//  Created by Kevin Babou on 4/5/22.
//

import UIKit

@objc protocol RecentTaskTableViewCellDelegate {
    @objc func didRateButtonPressed(_ recentTaskCell: RecentTaskTableViewCell, taskButtonTappedFor: String)
    @objc func didPayButtonPressed(_ recentTaskCell: RecentTaskTableViewCell, taskButtonTappedFor: String)
}

class RecentTaskTableViewCell: UITableViewCell {
    var task: Errand?
    var delegate: RecentTaskTableViewCellDelegate?
    
    @IBOutlet weak var taskerNameLabel: UILabel!
    
    @IBOutlet weak var taskNameLabel: UILabel!
    
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var paybuttonoutlet: UIButton!
    
    @IBAction func rateButtonTapped(_ sender: UIButton) {
            self.delegate?.didRateButtonPressed(self, taskButtonTappedFor: task!.taskDescription)
        }
//        delegate?.didRateButtonPressed()
        // We've got the index path for the cell that contains the button, now do something with it.
        

    
    @IBAction func payButtonTapped(_ sender: UIButton) {
       self.delegate?.didPayButtonPressed(self, taskButtonTappedFor: task!.taskDescription)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.rateButton.addTarget(self, action: #selector(rateButtonTapped(_:)), for: .touchUpInside)
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
