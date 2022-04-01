//
//  MyCollectionViewCell.swift
//  tasker
//
//  Created by Jeffrey Viramontes on 2/13/22.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbCity: UILabel!
    @IBOutlet weak var lbDesc: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbCategory: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.cornerRadius = 10.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.black.cgColor
        lbPrice.frame = CGRect(x:0,y:0,width:100,height:100)
        }
}
