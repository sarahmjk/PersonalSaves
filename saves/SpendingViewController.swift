//
//  SpendingViewController.swift
//  saves
//
//  Created by Sarah Minji Kim on 4/23/19.
//  Copyright © 2019 Sarah Minji Kim. All rights reserved.
//

import UIKit

class SpendingViewController: UIViewController {

    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var totalSpent: UILabel!
    struct SpendListItem {
        var spendingName = ""
        var spendingDate = ""
    }
    var totalSpent = 0
    var SpendListItems: [SpendListItem] = []

    @IBOutlet weak var spendingTableView: UITableView!
    var spendingNames: [String] = []
    var spendingDates: [String] = []
    var spendingCosts: [String]=[]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        spendingTableView.delegate = self
        spendingTableView.dataSource = self
        
        for _ in 0..<spendingCosts.count{
            spendingCost.append("")
        }
        
        for _ in 0..<spendingNames.count{
            spendingDate.append("")
        }
        
        for spendingName in spendingNames {
        SpendListItems.append(SpendListItem(spendingName: spendingName, spendingDate: ""))
        }
        for spendListItem in SpendListItems {
            print(spendListItem.spendingName, spendListItem.spendingDate)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItemDetail" {
            let destination = segue.destination as! SpendingDetailViewController
            var selectedIndexPath = tableView.indexPathForSelectedRow
            destination.spendingName = spendingNames[selectedIndexPath!.row]
            destination.spendingDate = spendingDates[selectedIndexPath!.row]
        } else {
            if let selectedPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedPath, animated: true)
            }
        }
    }
    
    func totalSpentValue () {
        let doubleSpendingCosts = spendingCosts.compactMap(Double.init)
        let totalspending = doubleSpendingCosts.reduce(0, +)
        totalSpent.text = totalspending
        
    }
    
    @IBAction func unwindFromItemDetailViewController(segue: UIStoryboardSegue) {
        let source = segue.source as! ItemDetailViewController
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            spendingNames[selectedIndexPath.row] = source.spendingName
            spendingDates[selectedIndexPath.row] = source.spendingDate
        } else {
            let newIndexPath = IndexPath(row: spendingNames.count, section: 0)
            spendingNames.append(source.spendingName)
            spendingDates.append(source.spendingDate)
            tableView.insertRows(at: [newIndexPath], with: .bottom)
            tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
        }
    }
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            addBarButton.title = "Edit"
            addBarButton.isEnabled = true
        } else {
            tableView.setEditing(true, animated: true)
            editBarButton.title = "Done"
            addBarButton.isEnabled = false
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
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRowInSection = \(spendingNames.count)")
        return spendingNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = spendingNames[indexPath.row]
        cell.detailTextLabel?.text = spendingDates[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            PartyListItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = SpendListItems[sourceIndexPath.row]
        SpendListItems.remove(at: sourceIndexPath.row)
        SpendListItems.insert(itemToMove, at: destinationIndexPath.row)
    }
    
}

