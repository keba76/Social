//
//  Post.swift
//  Social
//
//  Created by Ievgen Keba on 11/6/16.
//  Copyright © 2016 Harman Inc. All rights reserved.
//

import Foundation
import Firebase

class Post {
    
    
    private var _caption: String!
    private var _imageURL: String!
    private var _likes: Int!
    private var _postKey: String!
    private var _postRef: FIRDatabaseReference!
    
    var caption: String {
        return _caption
    }
    var imageURL: String {
        return _imageURL
    }
    var likes: Int {
        return _likes
    }
    var postKey: String {
        return _postKey
    }
    
    init(caption: String, imageURL: String, likes: Int) {
        self._caption = caption
        self._imageURL = imageURL
        self._likes = likes
    }
    init(postKey: String, postData: Dictionary<String, AnyObject>) {
        print(postData)
        self._postKey = postKey
        if let caption = postData["caption"] as? String {
            self._caption = caption
        }
        
        if let imageURL = postData["imageURL"] as? String {
            self._imageURL = imageURL
        }
        if let likes = postData["likes"] as? Int {
            self._likes = likes
        }
        self._postRef = DataService.ds.refPosts.child(self._postKey)
    }
    
    func adjustLikes(addLikes: Bool) {
        self._likes = addLikes ? self._likes + 1 : self._likes - 1
        self._postRef.child("likes").setValue(self._likes) 
    }
}

