//
//  SearchResultsTableViewCell.swift
//  tasker
//
//  Created by Kevin Babou on 3/14/22.
//

import UIKit

class SearchResultsTableViewCell: UITableViewCell {

    @IBOutlet weak var taskerName: UILabel!
    @IBOutlet weak var taskerCity: UILabel!
    @IBOutlet weak var taskerRating: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
