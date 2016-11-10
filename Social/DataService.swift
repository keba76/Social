//
//  DataService.swift
//  Social
//
//  Created by Ievgen Keba on 11/6/16.
//  Copyright © 2016 Harman Inc. All rights reserved.
//

import Foundation
import  Firebase
import SwiftKeychainWrapper


enum ConectionDB {
    static let connect = FIRDatabase.database().reference()
    static let storage = FIRStorage.storage().reference()
}

class DataService {
    // singleton
    static let ds = DataService()
    
    private var _refPosts = ConectionDB.connect.child("posts")
    private var _refUsers = ConectionDB.connect.child("users")
    
    private var _refStoragePost = ConectionDB.storage.child("post-pics")
    
    var refPosts: FIRDatabaseReference {
        return _refPosts
    }
    var refUsers: FIRDatabaseReference {
        return _refUsers
    }
    var refStorage: FIRStorageReference {
        return _refStoragePost
    }
    var refUserCurrent: FIRDatabaseReference {
        let uid = KeychainWrapper.standard.string(forKey: KEY_UID)
        return self._refUsers.child(uid!)
    }
    
    func createFirebaseDBUsers(uid: String, userData: Dictionary<String, String>) {
        refUsers.child(uid).updateChildValues(userData)
    }
    
}
