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
    
//    struct EarningListItem {
//        var earningName = ""
//        var earningDate = ""
//        var earningCost = 0.0
//        var earningReview = ""
//    }
    
    var totalEarning = 0.0
    var earningSpot: EarningSpot!
    var earningSpots: EarningSpots!
//    var EarningListItems: [EarningListItem] = []
    
    
//    var earningNames: [String] = []
//    var earningDates: [String] = []
//    var earningCosts: [Double] = []
//    var earningReviews: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        EarningTableView.delegate = self
//        EarningTableView.dataSource = self
        totalEarningLabel.text = String(totalEarning)
        
        if earningSpot == nil {
            earningSpot = EarningSpot()
        }
        
        earningSpots = EarningSpots()
//        for _ in 0..<EarningSpots.count{
//            earningCosts.append(0.0)
//        }
//
//        for _ in 0..<earningNames.count{
//            earningDates.append("")
//        }
//        for _ in 0..<earningNames.count{
//            earningReviews.append("")
//        }
//
//        for earningName in earningNames {
//            EarningListItems.append(EarningListItem(earningName: earningName, earningDate: "", earningCost: 0.0, earningReview: ""))
//        }
//        for EarningListItem in EarningListItems {
//            print(EarningListItem.earningName, EarningListItem.earningDate)
//        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        earningSpots.loadData {
            self.earningTableView.reloadData()
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
    
    func totalEarningValue () {

        let totalEarning = self.totalEarning + earningSpot.earningCost
        totalEarningLabel.text = String(totalEarning)

    }

    @IBAction func unwindFromItemDetailViewController(segue: UIStoryboardSegue) {
        let source = segue.source as! EarningDetailViewController
        if let selectedIndexPath = earningTableView.indexPathForSelectedRow {
            earningSpots.earningSpotArray[selectedIndexPath.row] = source.earningSpot
        } else {
            let newIndexPath = IndexPath(row: earningSpots.earningSpotArray.count, section: 0)
            earningSpots.earningSpotArray.append(source.earningSpot)
            earningTableView.insertRows(at: [newIndexPath], with: .bottom)
            earningTableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
        }
    }
    

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
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = earningSpots.earningSpotArray[sourceIndexPath.row]
        earningSpots.earningSpotArray.remove(at: sourceIndexPath.row)
        earningSpots.earningSpotArray.insert(itemToMove, at: destinationIndexPath.row)
    }
    
}

