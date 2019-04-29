//
//  EarningDetailViewController.swift
//  saves
//
//  Created by Sarah Minji Kim on 4/27/19.
//  Copyright © 2019 Sarah Minji Kim. All rights reserved.
//

import UIKit
import Firebase

class EarningDetailViewController: UIViewController {

    @IBOutlet weak var earningNameField: UITextField!
    @IBOutlet weak var earningCostField: UITextField!
    @IBOutlet weak var earningDateField: UITextField!
    @IBOutlet weak var earningReviewField: UITextField!
    
    var earningSpot: EarningSpot!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if earningSpot == nil {
            earningSpot = EarningSpot()
        }
        earningNameField.text = earningSpot.earningName
        earningCostField.text = String(earningSpot.earningCost)
        earningDateField.text = earningSpot.earningDate
        earningReviewField.text = earningSpot.earningReview
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Unwind" {
            updateUserInterface()
        }
    }
    
    func updateUserInterface() {
        earningSpot.earningName = earningNameField.text!
        earningSpot.earningCost = Double(earningCostField.text!)!
        earningSpot.earningDate = earningDateField.text!
        earningSpot.earningReview = earningReviewField.text!
    }
    
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    

    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        leaveViewController()
    }
    
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        self.updateUserInterface()
        earningSpot.saveData { success in
            if success {
                self.leaveViewController()
            } else {
                print("ERROR")
            }
        }
    }
    
}
