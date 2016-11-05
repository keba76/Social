//
//  ViewController.swift
//  Social
//
//  Created by Ievgen Keba on 11/3/16.
//  Copyright © 2016 Harman Inc. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class MainVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func facebookBtnTaped(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self)  {(result, error) in
            if error != nil {
                print("HARMAN: Unable to authenticate with Facebook - \(error)")
            } else if result?.isCancelled == true {
                print("HARMAN: User cancelled Facebook authentication")
            } else {
                print("HARMAN: Successully authenticated with Facebook")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        
        FIRAuth.auth()?.signIn(with: credential , completion: {(result, error) in
            if error != nil {
                print("HARMAN: Unable to authenticate with FireBase - \(error)")
            } else {
                print("HARMAN: Successully authenticated with FireBase")
            }
        })
    }
}


