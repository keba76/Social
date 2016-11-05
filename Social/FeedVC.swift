//
//  FeedVC.swift
//  Social
//
//  Created by Ievgen Keba on 11/5/16.
//  Copyright © 2016 Harman Inc. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func signOut(_ sender: Any) {
        if KeychainWrapper.standard.removeObject(forKey: KEY_UID) {
            print("HARMAN: ID removed from chainkey")
        }
        try! FIRAuth.auth()?.signOut()
        dismiss(animated: true, completion: nil)
        
    }

    

}
