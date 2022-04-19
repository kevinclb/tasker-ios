//
//  TestViewController.swift
//  tasker
//
//  Created by Kevin Babou on 3/20/22.
//

import UIKit

class TestViewController: UIViewController {
    var task: Errand!
    
    @IBAction func postTaskButtonPressed(_ sender: UIButton) {
        print("post button pressed")
        if task == nil {
            print("task not set yet")
        } else {
            do {
                let docRef = try db.collection("tasks").addDocument(from: task.self)
            } catch {
                print("error adding document to firebase")
            }
            
        }
    }
    
    
    @IBAction func fetchTaskButtonPressed(_ sender: UIButton) {
        print("fetch button pressed")
    }
    
    
    @IBAction func createTaskButtonPressed(_ sender: UIButton) {
        self.task = Errand(
            taskID: "432421",
            title: "title",
            category: "category",
            taskDescription: "description",
            employeeID: "1234",
            isCompleted: false,
            hasPaid: false,
            employeeRated: false,
            clientRated: false,
            location: Address(),
            negotiable: true,
            price: 25)
    }
    
    
    @IBAction func createUserButtonPressed(_ sender: UIButton) {
        print("create button pressed")
    }
    
    
    @IBAction func postUserButtonPressed(_ sender: UIButton) {
        print("post button pressed")
    }
    
    
    @IBAction func fetchUserButtonPressed(_ sender: UIButton) {
        print("fetch button pressed")
    }
    
    @IBAction func segueButtonPressed(_ sender: UIButton) {
        print("segueButtonPressed")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
