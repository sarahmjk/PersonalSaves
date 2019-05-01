//
//  Spot.swift
//  saves
//
//  Created by Sarah Minji Kim on 4/28/19.
//  Copyright © 2019 Sarah Minji Kim. All rights reserved.
//

import Foundation
import Firebase


class Spot{
    
    var spendingName: String
    var spendingCost: Double
    var spendingDate: String
    var spendingReview: String
    var documentID: String
   var postingUserID: String
    
    var dictionary: [String: Any] {
        return ["spendingName": spendingName, "spendingDate":spendingDate, "spendingCost": spendingCost, "spendingReview": spendingReview, "postingUserID": postingUserID]
    }
    
    init(spendingName: String, spendingDate: String,spendingCost: Double, spendingReview: String,documentID: String,  postingUserID: String) {
        self.spendingName = spendingName
        self.spendingDate = spendingDate
        self.spendingCost = spendingCost
        self.spendingReview = spendingReview
        self.documentID = documentID
        self.postingUserID = postingUserID
    }
    
    convenience init() {
        self.init(spendingName: "", spendingDate:"", spendingCost: 0.0, spendingReview: "",documentID: "", postingUserID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let spendingName = dictionary["spendingName"] as! String? ?? ""
        let spendingDate = dictionary["spendingDate"] as! String? ?? ""
        let spendingCost = dictionary["spendingCost"] as! Double? ?? 0.0
        let spendingReview = dictionary["spendingReview"] as! String? ?? ""
        self.init(spendingName: spendingName, spendingDate:spendingDate, spendingCost: spendingCost, spendingReview: spendingReview, documentID: "", postingUserID: "")
    }
    
    func saveData(completed: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        guard let postingUserID = (Auth.auth().currentUser?.uid) else {
            print("*** ERROR: Could not save data because we don't have a valid postingUserID")
            return completed(false)
        }
        self.postingUserID = postingUserID
        
        // Create the dictionary representing the data we want to save
        let dataToSave = self.dictionary
        
        // if we HAVE saved a record, we'll have a documentID
        if self.documentID != "" {
            let ref = db.collection("spots").document(self.documentID)
            ref.setData(dataToSave) { (error) in
                if let error = error {
                    print("*** ERROR: updating document \(self.documentID) \(error.localizedDescription)")
                    completed(false)
                } else {
                    print("^^^ Document updated with ref ID \(ref.documentID)")
                    completed(true)
                }
            }
        } else {
            var ref: DocumentReference? = nil // Let firestore create the new documentID
            ref = db.collection("spots").addDocument(data: dataToSave) { error in
                if let error = error {
                    print("*** ERROR: creating new document \(error.localizedDescription)")
                    completed(false)
                } else {
                    print("^^^ new document created with ref ID \(ref?.documentID ?? "unknown")")
                    self.documentID = ref!.documentID
                    completed(true)
                }
            }
        }
    }
    
//    func updateTotalSpent(completed: @escaping ()->()) {
//        let db = Firestore.firestore()
//        let spendingCostsRef = db.collection("spots").document(self.documentID).collection("spendingCosts")
//        spendingCostsRef.getDocuments { (querySnapshot, error) in
//            guard error == nil else {
//                return completed()
//            }
//            var totalSpent = 0.0
//            for document in querySnapshot!.documents { // go through all of the reviews documents
//                let spendingCostDictionary = document.data()
//                let spendingCost = spendingCostDictionary["spendingCost"] as! Double? ?? 0.0
//                totalSpent = totalSpent + Double(spendingCost)
//            }
//            let dataToSave = self.dictionary
//            let spotRef = db.collection("spots").document(self.documentID)
//            spotRef.setData(dataToSave) { error in // save it & check errors
//                guard error == nil else {
//                    return completed()
//                }
//                print("^^^ Document updated with ref ID \(self.documentID)")
//                completed()
//            }
//        }
//    }
}


