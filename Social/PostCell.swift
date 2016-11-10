//
//  PostCell.swift
//  Social
//
//  Created by Ievgen Keba on 11/5/16.
//  Copyright © 2016 Harman Inc. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {
    
    var post: Post!
    var likesRef: FIRDatabaseReference!
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likeLbl: UILabel!
    @IBOutlet weak var likeImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        self.likeImg.addGestureRecognizer(tap)
        likeImg.isUserInteractionEnabled = true
    }

    
    func configureCell (post: Post, img: UIImage? = nil) {
        self.post = post
        likesRef = DataService.ds.refUserCurrent.child("likes").child(post.postKey)
        self.likeLbl.text = String(post.likes)
        self.caption.text = post.caption
        if img != nil {
        self.postImg.image = img
        } else {
        let ref = FIRStorage.storage().reference(forURL: post.imageURL)
        ref.data(withMaxSize: 2 * 1024 * 1024, completion: {(data, error) in
            if error != nil {
                print("HARMAN: Unable to download image from Firebase storage")
            } else {
                print("HARMAN: Image to download from Firebase storage")
                if let imageData = data {
                    if let image = UIImage(data: imageData) {
                        self.postImg.image  = image
                        FeedVC.imageCache.setObject(image, forKey: post.imageURL as NSString)
                    }
                }
            }
        })
        }
    
        
        likesRef.observeSingleEvent(of: .value, with: {snapshot in
            if let _ = snapshot.value as? NSNull {
                self.likeImg.image = UIImage(named: "heartEmpty")
            } else {
                self.likeImg.image = UIImage(named: "heartFull")
            }
        })
        
    }
    
    func likeTapped(sender: UIGestureRecognizer) {
        likesRef.observeSingleEvent(of: .value, with: {snapshot in
            if let _ = snapshot.value as? NSNull {
                self.likeImg.image = UIImage(named: "heartFull")
                self.post.adjustLikes(addLikes: true)
                self.likesRef.setValue(true)
                LIKES = false
            } else {
                self.likeImg.image = UIImage(named: "heartEmpty")
                self.post.adjustLikes(addLikes: false)
                self.likesRef.removeValue()
                LIKES = false
            }
        })
        LIKES = true
    }

}
