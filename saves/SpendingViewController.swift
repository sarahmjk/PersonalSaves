//
//  SpendingViewController.swift
//  saves
//
//  Created by Sarah Minji Kim on 4/23/19.
//  Copyright © 2019 Sarah Minji Kim. All rights reserved.
//

import UIKit
import Firebase

class SpendingViewController: UIViewController {

    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var totalSpentLabel: UILabel!
    @IBOutlet weak var spendingTableView: UITableView!
    
    var defaultsData = UserDefaults.standard
    
    var totalSpent = 0.0
    var spot: Spot!
    var spots: Spots!
    var photos: Photos!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if spot == nil {
            spot = Spot()
        }
        
        spots = Spots()
        photos = Photos()
        
        totalSpent = defaultsData.double(forKey: "totalSpent")
        

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
            spots.loadData {
                self.spendingTableView.reloadData()
                self.totalSpent = 0.0
                for spot in self.spots.spotArray {
                    self.totalSpent = self.totalSpent + spot.spendingCost
                    self.photos.loadData(spot: spot) {
                        self.spendingTableView.reloadData()
                    }
                }
                self.defaultsData.set(self.totalSpent, forKey: "totalSpent")
                self.totalSpentLabel.text = String(self.totalSpent)
            }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowItemDetail" {
            let destination = segue.destination as! SpendingDetailViewController
            var selectedIndexPath = spendingTableView.indexPathForSelectedRow
            destination.spot = spots.spotArray[selectedIndexPath!.row]

        } else {
            if let selectedPath = spendingTableView.indexPathForSelectedRow {
                spendingTableView.deselectRow(at: selectedPath, animated: true)
            }
        }
    }
    

    func totalSpendingValue () {
    
        totalSpent = totalSpent + spot.spendingCost
        totalSpentLabel.text = String(totalSpent)
        
    }
    
    @IBAction func unwindFromItemDetailViewController(segue: UIStoryboardSegue) {
        let source = segue.source as! SpendingDetailViewController
        if let selectedIndexPath = spendingTableView.indexPathForSelectedRow {
            spots.spotArray[selectedIndexPath.row] = source.spot
        } else {
            let newIndexPath = IndexPath(row: spots.spotArray.count, section: 0)
            spots.spotArray.append(source.spot)
            spendingTableView.insertRows(at: [newIndexPath], with: .bottom)
            spendingTableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
        }
    }
    
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        if spendingTableView.isEditing {
            spendingTableView.setEditing(false, animated: true)
            editButton.title = "Edit"
            addButton.isEnabled = true
        } else {
            spendingTableView.setEditing(true, animated: true)
            editButton.title = "Done"
            addButton.isEnabled = false
        }
    }
    
    
   
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
            let isPresentingInAddMode = presentingViewController is UINavigationController
            if isPresentingInAddMode {
                dismiss(animated: true, completion: nil)
            } else {
                navigationController?.popViewController(animated: true)
            }
        }
    
}

extension SpendingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spots.spotArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = spots.spotArray[indexPath.row].spendingName
        cell.detailTextLabel?.text = spots.spotArray[indexPath.row].spendingDate
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            spots.spotArray.remove(at: indexPath.row)
            spendingTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = spots.spotArray[sourceIndexPath.row]
        spots.spotArray.remove(at: sourceIndexPath.row)
        spots.spotArray.insert(itemToMove, at: destinationIndexPath.row)
    }
    
}

