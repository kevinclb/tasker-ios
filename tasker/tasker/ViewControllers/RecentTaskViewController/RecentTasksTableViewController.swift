//
//  RecentTasksTableViewController.swift
//  tasker
//
//  Created by Kevin Babou on 4/5/22.
//

import UIKit
import Firebase

class RecentTasksTableViewController: UITableViewController {
    var recentTasks = [Errand]()
    var chosenRow = Int()
    var taskID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let collRef = db.collection("tasks")
        //in a prod app,
        //we would put the user's client ID here instead of searhing by employee ID
        //is user on employee page or on client page?
        collRef.whereField("employeeID", isEqualTo: "RVJioN7qcdX9G3KCugsNbJMqcJU2").getDocuments { querySnapshot, error in
            if error != nil {
                print("error retrieving documents: \(error?.localizedDescription)")
            }

            guard let snapshot = querySnapshot else {
                print("nil snapshot")
                return
            }
            
            for doc in snapshot.documents {
                do {
                    print("doc data: ", doc.data().description)
                    let task = try doc.data(as: Errand.self)!
                    self.recentTasks.append(task)
    
                } catch {
                    print("error decoding doc: \(error)")
                }
                
            }
            print("recent tasks count inside closure:", self.recentTasks.count)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        let nibCell = UINib(nibName: "RecentTaskTableViewCell", bundle: nil)
        tableView.register(nibCell, forCellReuseIdentifier: "recentTaskCell")
        RecentTaskTableViewCell.awakeFromNib()
        print("recent tasks count outside closure: ", recentTasks.count)
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return recentTasks.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.chosenRow = indexPath.row
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recentTaskCell", for: indexPath) as! RecentTaskTableViewCell
        cell.taskNameLabel.text = recentTasks[indexPath.row].taskDescription
        cell.taskerNameLabel.text = "test name"
        cell.task = recentTasks[indexPath.row]
        
        if(recentTasks[indexPath.row].hasPaid != true) {
            cell.paybuttonoutlet.backgroundColor = UIColor(red: 41/255.0, green: 191/255.0, blue: 157/255.0, alpha: 1)
            cell.paybuttonoutlet.layer.cornerRadius = 16
        }
        else{
            cell.paybuttonoutlet.backgroundColor = .gray
            cell.paybuttonoutlet.layer.cornerRadius = 16
            cell.paybuttonoutlet.isUserInteractionEnabled = false
        }
        
        if(recentTasks[indexPath.row].employeeRated != true) {
            cell.rateButton.backgroundColor = UIColor(red: 41/255.0, green: 191/255.0, blue: 157/255.0, alpha: 1)
            cell.rateButton.layer.cornerRadius = 16
        }
        else{
            cell.rateButton.backgroundColor = .gray
            cell.rateButton.layer.cornerRadius = 16
            cell.rateButton.isUserInteractionEnabled = false
        }
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}

extension RecentTasksTableViewController: RecentTaskTableViewCellDelegate {
    
    func didRateButtonPressed(_ recentTaskCell: RecentTaskTableViewCell, taskButtonTappedFor: String) {
        
        print("employeeID: ", recentTaskCell.task?.employeeID ?? "EMPTY TASK DESCRIPTION")
        print("Task ID:", taskID)
        //Here, Amir, you can tap into recentTaskCell.task's fields (employeeID, clientID, etc, and get whatever you need, then perform the transition below.)
        
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = .fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        // this code here is to make the viewcontroller we're presenting and make it show full screen then present it
        let rateVC = RateUserViewController()
        rateVC.setEmployeeID(employeeID: (recentTaskCell.task?.employeeID)!)
        rateVC.setDocID(docID: (recentTaskCell.task?.docID)!)
        print("EMPLOYEE ID: ", (recentTaskCell.task?.employeeID)!)
        print("DOC ID: ", (recentTaskCell.task?.docID)!)
        rateVC.modalPresentationStyle = .fullScreen
        // the app will automatically know how to animate the presentation, it will use the transition we made above on its own so that's why we set animated to false
        present(rateVC, animated: false, completion: nil)
        
    }
    
    func didPayButtonPressed(_ recentTaskCell: RecentTaskTableViewCell, taskButtonTappedFor: String) {
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = .fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        // this code here is to make the viewcontroller we're presenting and make it show full screen then present it
        let payVC = PaidMechanismViewController()
        payVC.setDocID(docID: (recentTaskCell.task?.docID)!)
        print("DOC ID: ", (recentTaskCell.task?.docID)!)
        payVC.modalPresentationStyle = .fullScreen
        present(payVC, animated: false, completion: nil)
    }
}
