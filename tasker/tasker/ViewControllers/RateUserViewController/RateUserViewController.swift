//
//  RateUserViewController.swift
//  tasker
//
//  Created by Amir Hammoud on 4/14/22.
//

import UIKit

class RateUserViewController: UIViewController {
    
    @IBOutlet weak var category1Label: UILabel!
    @IBOutlet var category1StarButtons: [UIButton]!
    
    @IBOutlet weak var category2Label: UILabel!
    @IBOutlet var category2StarButtons: [UIButton]!
    
    @IBOutlet weak var category3Label: UILabel!
    @IBOutlet var category3StarButtons: [UIButton]!
    
    @IBOutlet weak var completeButton: UIButton!
    
    @IBOutlet weak var backButton: UIButton!
    
    var category1Rating: Int = 0
    var category2Rating: Int = 0
    var category3Rating: Int  = 0
    let numOfCategories: Int = 3
    let maxRating: Int = 15
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func category1StarButtonTapped(_ sender: UIButton) {
        
        let tag = sender.tag
        
        for button in category1StarButtons {
            if button.tag <= tag {
                // Show as selected
                button.setTitle("★", for: .normal)
                category1Rating = Int(tag) + 1
            }
            else {
                button.setTitle("☆", for: .normal)
            }
        }
        print("Category 1 Rating: ", category1Rating)
    }
    
    @IBAction func category2StarButtonTapped(_ sender: UIButton) {
        
        let tag = sender.tag
        
        for button in category2StarButtons {
            if button.tag <= tag {
                // Show as selected
                button.setTitle("★", for: .normal)
                category2Rating = Int(tag) + 1
            }
            else {
                button.setTitle("☆", for: .normal)
            }
        }
        print("Category 2 Rating: ", category2Rating)
    }
    
    @IBAction func category3StarButtonTapped(_ sender: UIButton) {
        
        let tag = sender.tag
        
        for button in category3StarButtons {
            if button.tag <= tag {
                // Show as selected
                button.setTitle("★", for: .normal)
                category3Rating = Int(tag) + 1
            }
            else {
                button.setTitle("☆", for: .normal)
            }
        }
        print("Category 3 Rating: ", category3Rating)
    }
    
    @IBAction func completeButtonTapped(_ sender: Any) {
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        
        // This code here is to present from right to left instead of bottom to top
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = .fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false, completion: nil)
    }
    
    
    
    
    
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
