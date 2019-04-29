//
//  EarningSpots.swift
//  saves
//
//  Created by Sarah Minji Kim on 4/28/19.
//  Copyright © 2019 Sarah Minji Kim. All rights reserved.
//

import Foundation
import Firebase

class EarningSpots {
    var earningSpotArray = [EarningSpot]()
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(completed: @escaping () -> ())  {
        db.collection("EarningSpots").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("*** ERROR: adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.earningSpotArray = []
            // there are querySnapshot!.documents.count documents in teh spots snapshot
            for document in querySnapshot!.documents {
                let earningSpot = EarningSpot(dictionary: document.data())
                earningSpot.documentID = document.documentID
                self.earningSpotArray.append(earningSpot)
            }
            completed()
        }
    }
}
