//
//  EarningViewController.swift
//  saves
//
//  Created by Sarah Minji Kim on 4/23/19.
//  Copyright © 2019 Sarah Minji Kim. All rights reserved.
//

import UIKit

class EarningViewController: UIViewController {
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var totalEarnedLabel: UILabel!
    struct EarningListItem {
        var earningName = ""
        var earningDate = ""
    }
    
    var totalEarning = 0
    var EarningListItems: [EarningListItem] = []
    
    @IBOutlet weak var EarningTableView: UITableView!
    var earningNames: [String] = []
    var earningDates: [String] = []
    var earningCosts: [String]=[]
    override func viewDidLoad() {
        super.viewDidLoad()

        EarningTableView.delegate = self
        EarningTableView.dataSource = self
        
        for _ in 0..<earningCosts.count{
            earningCosts.append("")
        }
        
        for _ in 0..<earningNames.count{
            earningDates.append("")
        }
        
        for earningName in earningNames {
            EarningListItems.append(EarningListItem(earningName: earningName, earningDate: ""))
        }
        for EarningListItem in EarningListItems {
            print(EarningListItem.earningName, EarningListItem.earningDate)
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
