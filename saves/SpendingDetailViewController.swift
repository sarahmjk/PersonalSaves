//
//  SpendingDetailViewController.swift
//  saves
//
//  Created by Sarah Minji Kim on 4/23/19.
//  Copyright © 2019 Sarah Minji Kim. All rights reserved.
//

import UIKit

class SpendingDetailViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var spendingNameField: UITextField!
    @IBOutlet weak var spendingCostField: UITextField!
    @IBOutlet weak var spendingDateField: UITextField!
    @IBOutlet weak var imageOfProduct: UIImageView!
    
    var spendingName: String!
    var spendingCost: String!
    var spendingDate: String!
    var imagePicker = UIImagePickerController ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      

        if spendingName == nil {
            spendingCost = ""
            spendingName = ""
            spendingDate = ""
        }
        spendingNameField.text = spendingName
        spendingCostField.text = spendingCost
        spendingDateField.text = spendingDate
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UnwindFromSave" {
            spendingNameField.text = spendingName
            spendingCostField.text = spendingCost
            spendingDateField.text = spendingDate
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
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
    }
    
    

}
