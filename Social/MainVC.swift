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
import SwiftKeychainWrapper


class MainVC: UIViewController {
    
    @IBOutlet weak var emailField: DesignField!
    @IBOutlet weak var passwordField: DesignField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Load")
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Apear")
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
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
                if let uid = result?.uid {
                self.comleteSignIn(id: uid)
                }
            }
        })
    }
    @IBAction func SignInTopped(_ sender: Any) {
        if let email = emailField.text, let password = passwordField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: {(user, error) in
                if error == nil {
                    print("HARMAN: Email user authenticated with FireBase")
                    if let uid = user?.uid {
                        self.comleteSignIn(id: uid)
                    }
                    
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: {(user, error) in
                        if error != nil {
                            print("HARMAN: Unable to authenticate with FireBase using Email")
                        } else {
                            print("HARMAN: Successully authenticated with FireBase")
                            if let uid = user?.uid {
                                self.comleteSignIn(id: uid)
                            }
                        }
                    })
                }
            })
        }
    }
    
    func comleteSignIn(id: String) {
        let keychaunResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("Data saved to keychain \(keychaunResult)")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
    
}


