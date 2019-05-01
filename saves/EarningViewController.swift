//
//  EarningViewController.swift
//  saves
//
//  Created by Sarah Minji Kim on 4/23/19.
//  Copyright © 2019 Sarah Minji Kim. All rights reserved.
//

import UIKit
import Firebase

class EarningViewController: UIViewController {
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var totalEarningLabel: UILabel!
    @IBOutlet weak var earningTableView: UITableView!
    
    var totalEarning = 0.0
    var earningSpots: EarningSpots!
    
    var defaultsData = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        totalEarningLabel.text = String(totalEarning)
        
        earningSpots = EarningSpots()
        totalEarning = defaultsData.double(forKey: "totalEarning")
    }
    
    override func viewWillAppear(_ animated: Bool) { 
        earningSpots.loadData {
            self.earningTableView.reloadData()
            self.totalEarning = 0.0
            for earningSpot in self.earningSpots.earningSpotArray {
                self.totalEarning = self.totalEarning + earningSpot.earningCost
            }
            self.defaultsData.set(self.totalEarning, forKey: "totalEarning")
            self.totalEarningLabel.text = String(self.totalEarning)
            
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowItemDetailIncome" {
            let destination = segue.destination as! EarningDetailViewController
            var selectedIndexPath = earningTableView.indexPathForSelectedRow
            destination.earningSpot = earningSpots.earningSpotArray[selectedIndexPath!.row]
        } else {
            if let selectedPath = earningTableView.indexPathForSelectedRow {
                earningTableView.deselectRow(at: selectedPath, animated: true)
            }
        }
    }

//    @IBAction func unwindFromItemDetailViewController(segue: UIStoryboardSegue) {
//        let source = segue.source as! EarningDetailViewController
//        if let selectedIndexPath = earningTableView.indexPathForSelectedRow {
//            earningSpots.earningSpotArray[selectedIndexPath.row] = source.earningSpot
//        } else {
//            let newIndexPath = IndexPath(row: earningSpots.earningSpotArray.count, section: 0)
//            earningSpots.earningSpotArray.append(source.earningSpot)
//            earningTableView.insertRows(at: [newIndexPath], with: .bottom)
//            earningTableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
//        }
//    }
    

    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        if earningTableView.isEditing {
            earningTableView.setEditing(false, animated: true)
            editButton.title = "Edit"
            addButton.isEnabled = true
        } else {
            earningTableView.setEditing(true, animated: true)
            editButton.title = "Done"
            addButton.isEnabled = false
        }
    }
    
}

extension EarningViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return earningSpots.earningSpotArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EarningCell", for: indexPath)
        cell.textLabel?.text = earningSpots.earningSpotArray[indexPath.row].earningName
        cell.detailTextLabel?.text = earningSpots.earningSpotArray[indexPath.row].earningDate
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            earningSpots.earningSpotArray.remove(at: indexPath.row)
            earningTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = earningSpots.earningSpotArray[sourceIndexPath.row]
        earningSpots.earningSpotArray.remove(at: sourceIndexPath.row)
        earningSpots.earningSpotArray.insert(itemToMove, at: destinationIndexPath.row)
    }
    
}

