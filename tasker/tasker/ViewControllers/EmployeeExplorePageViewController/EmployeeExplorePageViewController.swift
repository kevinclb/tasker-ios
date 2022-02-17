//
//  EmployeeExplorePageViewController.swift
//  tasker
//
//  Created by Kevin Babou on 2/2/22.
//

import UIKit

class EmployeeExplorePageViewController: UIViewController{
    
    
    
    @IBOutlet var collectionView: UICollectionView!
    
    let taskCollectionViewCellId = "MyCollectionViewCell"
    
    var tasks = [task]()
    
    override func viewDidLoad() {
        let nibCell = UINib(nibName: taskCollectionViewCellId, bundle: nil)
        collectionView.register(nibCell, forCellWithReuseIdentifier: taskCollectionViewCellId)
        collectionView.delegate = self
        collectionView.dataSource = self
        MyCollectionViewCell.awakeFromNib()
        for _ in 1...25{
            let task = task()
            task.name = "Name"
            task.city = "City"
            task.taskInfo = "Task Description will go here"
            task.price = "Price"
            task.category = "Category"
            tasks.append(task)
        }
        collectionView.reloadData()
    }
}

extension EmployeeExplorePageViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: taskCollectionViewCellId, for: indexPath) as! MyCollectionViewCell
        let task = tasks[indexPath.row]
        cell.lbName.text = task.name!
        cell.lbCity.text = task.city!
        cell.lbDesc.text = task.taskInfo!
        cell.lbPrice.text = task.price!
        cell.lbCategory.text = task.category!
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let task = tasks[indexPath.row]
            print("\(indexPath.row) - \(task.name!)")
        }
    
    //fixing an issue
}
