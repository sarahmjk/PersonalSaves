//
//  Spot.swift
//  saves
//
//  Created by Sarah Minji Kim on 4/28/19.
//  Copyright © 2019 Sarah Minji Kim. All rights reserved.
//

import Foundation
import Firebase

class EarningSpot{
    
    var earningName: String
    var earningCost: Double
    var earningDate: String
    var earningReview: String
    var documentID: String
    var postingUserID: String
    
    var dictionary: [String: Any] {
        return ["earningName": earningName, "earningDate":earningDate, "searningCost": earningCost, "earningReview": earningReview, "postingUserID": postingUserID]
    }
    
    init(earningName: String, earningDate: String,earningCost: Double, earningReview: String,documentID: String, postingUserID: String) {
        self.earningName = earningName
        self.earningDate = earningDate
        self.earningCost = earningCost
        self.earningReview = earningReview
        self.documentID = documentID
        self.postingUserID = postingUserID
    }
    
    convenience init() {
        self.init(earningName: "", earningDate:"", earningCost: 0.0, earningReview: "",documentID: "", postingUserID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let earningName = dictionary["earningName"] as! String? ?? ""
        let earningDate = dictionary["earningDate"] as! String? ?? ""
        let earningCost = dictionary["earningCost"] as! Double? ?? 0.0
        let earningReview = dictionary["earningReview"] as! String? ?? ""
        self.init(earningName: earningName, earningDate: earningDate, earningCost: earningCost, earningReview: earningReview, documentID: "", postingUserID: "")
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
            let ref = db.collection("EarningSpots").document(self.documentID)
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
            ref = db.collection("EarningSpots").addDocument(data: dataToSave) { error in
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
//        let earningCostsRef = db.collection("spots").document(self.documentID).collection("earningCosts")
//        earningCostsRef.getDocuments { (querySnapshot, error) in
//            guard error == nil else {
//                return completed()
//            }
//            var totalEarning = 0.0
//            for document in querySnapshot!.documents { // go through all of the reviews documents
//                let earningCostDictionary = document.data()
//                let earningCost = earningCostDictionary["earningCost"] as! Double? ?? 0.0
//                totalEarning = totalEarning + Double(earningCost)
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


