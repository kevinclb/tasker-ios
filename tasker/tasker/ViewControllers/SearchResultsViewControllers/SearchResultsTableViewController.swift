//
//  SearchResultsTableViewController.swift
//  tasker
//
//  Created by Kevin Babou on 3/14/22.
//

import UIKit
import FirebaseFirestore

class SearchResultsTableViewController: UITableViewController {
    var uid = ""
    var searchQuery = ""
    var resultsTaskers = [User]()
    var noResults: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uid = Utilities.getUid()
        guard searchQuery != "" else { print("search query blank"); return }
        
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        let nibCell = UINib(nibName: "SearchResultsTableViewCell", bundle: nil)
        tableView.register(nibCell, forCellReuseIdentifier: "SearchResultsTableViewCell")
        SearchResultsTableViewCell.awakeFromNib()
        
        let collectionRef = db.collection("users")
        collectionRef.whereField("employee", isEqualTo: true)
            .whereField("address.city", isEqualTo: searchQuery)
            .getDocuments(source: FirestoreSource.server) { snapshot, error in
                guard error == nil else { print("error retrieving search results: \(String(describing: error?.localizedDescription))"); return }
                guard let snapshot = snapshot else { print("invalid snapshot"); return }
                guard !snapshot.isEmpty else { print("empty snapshot"); self.noResults = true; return }
                for document in snapshot.documents {
                    do {
                        try self.resultsTaskers.append(document.data(as: User.self)!)
                    } catch {
                        print("error decoding result tasker document data")
                    }
                }
                DispatchQueue.main.async {
                    print("loading search results")
                    self.tableView.reloadData()
                }
            }
        
        print("searchQuery: ", searchQuery)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return resultsTaskers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultsTableViewCell", for: indexPath) as! SearchResultsTableViewCell
        
        // Configure the cell...
        cell.taskerName.text = resultsTaskers[indexPath.row].firstname ?? "no first name"
        cell.taskerCity.text = resultsTaskers[indexPath.row].address?.city ?? "no city"
        cell.taskerRating.text = String(resultsTaskers[indexPath.row].rating ?? 0)
        cell.layoutMargins = UIEdgeInsets.zero
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
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
