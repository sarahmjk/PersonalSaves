//
//  ViewController.swift
//  saves
//
//  Created by Sarah Minji Kim on 4/22/19.
//  Copyright © 2019 Sarah Minji Kim. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import GoogleSignIn

class ViewController: UIViewController {

    @IBOutlet weak var budgetLabel: UITextField!
    @IBOutlet weak var nonBudgetLabel: UILabel!
    @IBOutlet weak var canSpendLabel: UILabel!
    
    var authUI: FUIAuth!
    var budgetAmount = 0.0
    var canSpend = 0.0
    var nonBudget = 0.0
    
    var totalSpent: Double!
    var totalEarning: Double!
    var defaultsData = UserDefaults.standard
    
    var spots: Spots!
    var earningSpots: EarningSpots!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        authUI = FUIAuth.defaultAuthUI()
        authUI.delegate = self
        
        spots = Spots()
        earningSpots = EarningSpots()
        
        spots.loadData {
            print("loading spots")
        }
        
        earningSpots.loadData {
            self.totalEarning = self.earningSpots.totalCost()
            if self.earningSpots.totalCost() < self.budgetAmount {
                self.nonBudget = 0.0
            } else {
                self.nonBudget = self.earningSpots.totalCost() - self.budgetAmount
            }
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        signIn()
        budgetAmount = defaultsData.double(forKey: "budgetAmount")
        totalSpent = defaultsData.double(forKey: "totalSpent")
        totalEarning = defaultsData.double(forKey: "totalEarning")
        
        updateUI()
        
    }
    
    func updateUI() {
        canSpend = budgetAmount - totalSpent
        if totalEarning < budgetAmount {
            nonBudget = 0.0
        } else {
            nonBudget = totalEarning - budgetAmount
        }
        canSpendLabel.text = String(canSpend)
        nonBudgetLabel.text = String(nonBudget)
    }
    
    @IBAction func calcButtonPressed(_ sender: Any) {
        budgetAmount = Double(budgetLabel.text!)!
        defaultsData.set(budgetAmount, forKey: "budgetAmount")
        updateUI()
    }
    
    func signIn() {
        let providers: [FUIAuthProvider] = [FUIGoogleAuth()]
        if authUI.auth?.currentUser == nil {
            self.authUI.providers = providers
            present(authUI.authViewController(), animated: true, completion: nil)
        }
    }
    
}

extension ViewController: FUIAuthDelegate {
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        // other URL handling goes here.
        return false
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        if let user = user {
            print("*** We signed in with the user \(user.email ?? "unknown e-mail")")
        }
    }
}
