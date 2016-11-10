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

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageAdd: DesignImage!
    @IBOutlet weak var captionField: DesignField!
    
    
    static var imageCache = NSCache<NSString, UIImage>()
    var imageSelected = false
    
    var imagePicker: UIImagePickerController!
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        DataService.ds.refPosts.observe(.value, with: {(snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        if LIKES {
                            self.posts.insert(post, at: 0)
                        }
                        // use class Hashable for remove dublicate in posts array.
                        let wrappers = self.posts.map { (p) -> HashableWrapper<Post> in
                            return HashableWrapper<Post>(obj: p, equal: { (obj1, obj2) -> Bool in
                                return obj1.postKey == obj2.postKey
                            }, hash: { (obj) -> Int in
                                return obj.likes
                            })
                        }
                        self.posts = wrappers.removeDuplicates().map { (w) -> Post in
                            return w.object
                        }
                    }
                }
            }
            self.tableView.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell {
            if let image = FeedVC.imageCache.object(forKey: posts[indexPath.row].imageURL as NSString) {
                cell.configureCell(post: posts[indexPath.row], img: image)
            } else {
                cell.configureCell(post: posts[indexPath.row])
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    @IBAction func addImageTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func postBtnTopped(_ sender: Any) {
        guard let caption = captionField.text, caption != "" else {
            print("HARMAN: Caption must be entered")
            return
        }
        guard let image = imageAdd.image else {
            print("HARMAN: An image must be selected")
            return
        }
        
        if let imgData = UIImageJPEGRepresentation(image, 0.2), imageSelected {
            
            let imgUid = UUID().uuidString
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpeg"
            
            DataService.ds.refStorage.child(imgUid).put(imgData, metadata: metaData, completion: { (metadata, error) in
                if error != nil {
                    print("HARMAN: Unable to upload image to Firebase storage")
                } else {
                    print("HARMAN: Successfully uploaded image to Firebase storage")
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    if let url = downloadURL{
                        self.postToFirebase(imgURL: url)
                    }
                }
            })
        }
        
    }
    
    func postToFirebase(imgURL: String) {
        
        let post: Dictionary<String, AnyObject> = [
            "caption" : captionField.text! as AnyObject,
            "imageURL" : imgURL as AnyObject,
            "likes" : 0 as AnyObject
        ]
        let firebasePost = DataService.ds.refPosts.childByAutoId()
        firebasePost.setValue(post)
        captionField.text = ""
        imageSelected = false
        imageAdd.image = UIImage(named: "camera")
        tableView.reloadData()
    }
    
    
    @IBAction func signOut(_ sender: Any) {
        print(#function)
        if KeychainWrapper.standard.removeObject(forKey: KEY_UID) {
            print("HARMAN: ID removed from chainkey")
        }
        try! FIRAuth.auth()?.signOut()
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageAdd.image = image
            imageSelected = true
        } else {
            print("image not work")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
}

extension Array where Element: Hashable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()
        
        for value in self {
            if result.contains(value) == false {
                result.insert(value, at: 0)
            }
        }
        return result
    }
}



