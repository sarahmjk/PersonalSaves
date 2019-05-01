//
//  SpendingDetailViewController.swift
//  saves
//
//  Created by Sarah Minji Kim on 4/23/19.
//  Copyright © 2019 Sarah Minji Kim. All rights reserved.
//

import UIKit
import Firebase


class SpendingDetailViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var spendingNameField: UITextField!
    @IBOutlet weak var spendingCostField: UITextField!
    @IBOutlet weak var spendingDateField: UITextField!
    @IBOutlet weak var spendingReviewField: UITextField!
    @IBOutlet weak var imageOfProduct: UIImageView!

    var imagePicker = UIImagePickerController ()
    var photos: Photos!
    var spot: Spot!
    var photo: Photo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        imagePicker.delegate = self
        
        if spot == nil {
            spot = Spot()
        }
        if photo == nil {
            photo = Photo()
        }
        
        photos = Photos()
        
        spendingNameField.text = spot.spendingName
        spendingCostField.text = String(spot.spendingCost)
        spendingDateField.text = spot.spendingDate
        spendingReviewField.text = spot.spendingReview
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        photos.loadData(spot: spot) {
            self.imageOfProduct.image = self.photo.image
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UnwindFromSave" {
            updateUserInterface()
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
    
    func updateUserInterface() {
        spot.spendingName = spendingNameField.text!
        spot.spendingCost = Double(spendingCostField.text!)!
        spot.spendingDate = spendingDateField.text!
        spot.spendingReview = spendingReviewField.text!
    }
    
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func saveCancelAlert(title: String, message: String, segueIdentifier: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { (_) in
            self.spot.saveData { success in
//                self.saveButton.title = "Done"
//                self.cancelButton.title = ""
                self.navigationController?.setToolbarHidden(true, animated: true)
//                self.disableTextEditing()
                if segueIdentifier == "AddReview" {
                    self.performSegue(withIdentifier: segueIdentifier, sender: nil)
                } else {
                    self.cameraOrLibraryAlert()
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func addPhotoPressed(_ sender: Any) {
        if spot.documentID == "" {
            saveCancelAlert(title: "This Venue Has Not Been Saved", message: "You must save this venue before you can add a photo", segueIdentifier: "AddPhoto")
        } else {
            cameraOrLibraryAlert()
        }
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        leaveViewController()
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        self.updateUserInterface()
        spot.saveData { success in
            if success {
                self.leaveViewController()
            } else {
                print("ERROR")
            }
        }
    }

}

extension SpendingDetailViewController   {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let photo = Photo()
        photo.image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imageOfProduct.image = photo.image
        dismiss(animated: true) {
            photo.saveData(spot: self.spot) { (success) in
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
