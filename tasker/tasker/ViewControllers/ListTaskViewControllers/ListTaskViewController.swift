//
//  ListTaskViewController.swift
//  tasker
//
//  Created by Kevin Babou on 3/19/22.
//

import UIKit

class ListTaskViewController: UIViewController {
    var uid: String!
    var titleText: String!
    var categoryText: String!
    var taskDescription: String!
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var taskDescriptionTextField: UITextField!
    
    @IBAction func continueButtonPressed(_ sender: UIButton) {
        navigateToSubmitVC()
    }
    @IBAction func Button(_ sender: UIButton) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func titleTextEditingEnded(_ sender: UITextField) {
        //TODO: add better text validation here to prevent people from pressing continue with empty fields
        self.titleText = titleTextField.text ?? ""
        sender.resignFirstResponder()
    }
    @IBAction func categoryTextFieldEditingEnded(_ sender: UITextField) {
        //TODO: add better text validation here to prevent people from pressing continue with empty fields
        self.categoryText = categoryTextField.text ?? ""
        sender.resignFirstResponder()
        print("category text:", self.categoryText ?? "none")
    }
    
    @IBAction func descriptionTextFieldEditingEnded(_ sender: UITextField) {
        //TODO: add better text validation here to prevent people from pressing continue with empty fields
        self.taskDescription = taskDescriptionTextField.text ?? ""
        print("taskDescription text:", self.taskDescription ?? "none")
        sender.resignFirstResponder()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.uid = Utilities.getUid()
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
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

extension ListTaskViewController {
    
    
    func navigateToHomeVC(_ newViewController: UIViewController, _ transitionFrom:CATransitionSubtype) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.moveIn
        transition.subtype = transitionFrom
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        
        
        // this code here is to make the viewcontroller we're presenting and make it show full screen then present it
        let newVC = newViewController
        newVC.modalPresentationStyle = .fullScreen
        // the app will automatically know how to animate the presentation, it will use the transition we made above on its own so that's why we set animated to false
        self.present(newVC, animated: false, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.view.endEditing(true)
            return false
    }
    
    func navigateToSubmitVC() {
        let taskToList = Errand(title: self.titleText ?? "", category: self.categoryText ?? "", taskDescription: self.taskDescription ?? "", employeeID: self.uid, isCompleted: false)
        let submitVC = SubmitTaskViewController(inputTask: taskToList)
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromRight
        submitVC.modalPresentationStyle = .fullScreen
        self.view.window!.layer.add(transition, forKey: nil)
        self.present(submitVC, animated: false)
    }
    
}
