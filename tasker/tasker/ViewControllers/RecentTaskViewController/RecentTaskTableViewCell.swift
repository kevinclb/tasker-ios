//
//  RecentTaskTableViewCell.swift
//  tasker
//
//  Created by Kevin Babou on 4/5/22.
//

import UIKit
import Firebase

@objc protocol RecentTaskTableViewCellDelegate {
    @objc func didRateButtonPressed(_ recentTaskCell: RecentTaskTableViewCell, taskButtonTappedFor: String)
}

class RecentTaskTableViewCell: UITableViewCell {
    var task: Errand?
    var delegate: RecentTaskTableViewCellDelegate?
    
    @IBOutlet weak var taskerNameLabel: UILabel!
    
    @IBOutlet weak var taskNameLabel: UILabel!
    
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var paybuttonoutlet: UIButton!
    @IBAction func rateButtonTapped(_ sender: UIButton) {
        print("rate button tapped")
            self.delegate?.didRateButtonPressed(self, taskButtonTappedFor: task!.taskDescription)
        }
//        delegate?.didRateButtonPressed()
        // We've got the index path for the cell that contains the button, now do something with it.
        

    
    @IBAction func payButtonTapped(_ sender: UIButton) {
        self.paybuttonoutlet.backgroundColor = UIColor(red: 41/255.0, green: 191/255.0, blue: 157/255.0, alpha: 1)
        let db = Firestore.firestore()
        //db.collection("users").document(userID).setData(["num_ratings": (numOfRatings + 1), "rating": roundedRating, "employeeRated": true], merge: true)
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
