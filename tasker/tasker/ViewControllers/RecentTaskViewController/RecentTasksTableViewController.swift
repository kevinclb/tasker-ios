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
    var names = ["John Doe", "Clark Kent", "Albert Einstein", "Roger Federer", "Sally Mae"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let collRef = db.collection("tasks")
        //in a prod app,
        //we would put the user's client ID here instead of searhing by employee ID
        collRef.whereField("employeeID", isEqualTo: "RVJioN7qcdX9G3KCugsNbJMqcJU2").getDocuments { snapshot, error in
            if error != nil {
                print("error retrieving documents: \(error?.localizedDescription)")
            }
            guard let snapshot = snapshot else {
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

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recentTaskCell", for: indexPath) as! RecentTaskTableViewCell
        cell.taskNameLabel.text = recentTasks[indexPath.row].taskDescription
        cell.taskerNameLabel.text = names[indexPath.row]
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
