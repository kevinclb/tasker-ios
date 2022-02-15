//
//  MyCollectionViewCell.swift
//  tasker
//
//  Created by Jeffrey Viramontes on 2/13/22.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {


//    @IBOutlet weak var myLabel: UILabel!
//
//    static let identifier = "MyCollectionViewCell"
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//
//    }

//    public func configure(with image: UIImage){
//        imageView.image = image
//    }
//
//    public func configure(with label: UILabel){
//        myLabel.text = label.text
//    }
//
//    static func nib() -> UINib{
//        return UINib(nibName: "MyCollectionViewCell", bundle: nil)
//    }
    
    static let identifier = "MyCollectionViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    static func nib() -> UINib{
        return UINib(nibName: "MyCollectionViewCell", bundle: nil)
    }
    private let priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.text = "Price"
        priceLabel.textColor = UIColor.green
        return priceLabel
    }()

    private let taskLabel: UILabel = {
        let taskLabel = UILabel()
        taskLabel.text = "Task information will go here"
        return taskLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .lightGray
        contentView.addSubview(priceLabel)
        contentView.addSubview(taskLabel)

    }

    required init?(coder: NSCoder) {
        fatalError("has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        priceLabel.frame = CGRect(x: 5, y: contentView.frame.size.height-50, width: contentView.frame.size.width-10, height: 50)
        taskLabel.frame = CGRect(x: 5, y: 0, width: contentView.frame.size.width-10, height:contentView.frame.size.height-50)
    }
}
