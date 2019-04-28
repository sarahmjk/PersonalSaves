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
    @IBOutlet weak var spendingReviewField: UITextField!
    @IBOutlet weak var imageOfProduct: UIImageView!
    
    var spendingName: String!
    var spendingCost: String!
    var spendingDate: String!
    var spendingReview: String!
    var imagePicker = UIImagePickerController ()
    var photos: Photos!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        imagePicker.delegate = self
        
        if spendingName == nil {
            spendingCost = ""
            spendingName = ""
            spendingDate = ""
            spendingReview = ""
        }
        spendingNameField.text = spendingName
        spendingCostField.text = spendingCost
        spendingDateField.text = spendingDate
        spendingReviewField.text = spendingReview
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UnwindFromSave" {
            spendingNameField.text = spendingName
            spendingCostField.text = spendingCost
            spendingDateField.text = spendingDate
            
        }
    }
    
    func cameraOrLibraryAlert() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            self.accessCamera()
        }
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { _ in
            self.accessLibrary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func addPhotoPressed(_ sender: Any) {
        cameraOrLibraryAlert()
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

extension SpendingDetailViewController   {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let photo = Photo()
        photo.image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        dismiss(animated: true) {
            photo.saveData() { (success) in
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func accessLibrary() {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func accessCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        } else {
            showAlert(title: "Camera Not Available", message: "There is no camera available on this device.")
        }
    }
}
