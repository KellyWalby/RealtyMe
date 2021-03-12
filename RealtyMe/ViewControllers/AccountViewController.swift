//
//  AccountViewController.swift
//  RealtyMe
//
//  Created by Kelly Walby on 3/12/21.
//  Copyright © 2021 Kelly Walby. All rights reserved.
//

import UIKit
import Firebase

class AccountViewController: UIViewController {
    
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var addListingButton: UIButton!
    @IBOutlet weak var homeToolbarButton: UIBarButtonItem!
    @IBOutlet weak var messageToolbarButton: UIBarButtonItem!
    @IBOutlet weak var notificationToolbarButton: UIBarButtonItem!
    @IBOutlet weak var accountToolbarButton: UIBarButtonItem!
    @IBOutlet weak var bioTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bioTextView.isEditable = false
        
        getName { (name) in
            if let name = name {
                self.profileName.text = name
            }
        }
        getBio { (bio) in
            if let bio = bio {
                self.bioTextView.text = bio
            }
        }
        getUsername { (username) in
            if let username = username {
                self.username.text = username
            }
        }
    }
    //function to retrieve user's name from db to display on user's profile
    func getName (completion: @escaping (_ name: String?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid //unwrap safetly in case user is not logged in
        else {
            completion(nil) //user is not logged in
            return
        }
        Firestore.firestore().collection("users").document(uid).getDocument { (docSnapshot, error) in
            if let doc = docSnapshot {
                if let name = doc.get("name") as? String {
                    completion(name) //success; return name
                } else {
                    print ("error getting field")
                    completion(nil)
                }
            }else {
                if let error = error {
                    print (error)
                }
                completion(nil)
            
            }
            
        }
    }
    //function to retrieve user's name from db to display on user's profile
    func getBio (completion: @escaping (_ name: String?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid //unwrap safetly in case user is not logged in
        else {
            completion(nil) //user is not logged in
            return
        }
        Firestore.firestore().collection("users").document(uid).getDocument { (docSnapshot, error) in
            if let doc = docSnapshot {
                if let name = doc.get("bio") as? String {
                    completion(name) //success; return name
                } else {
                    print ("error getting field")
                    completion(nil)
                }
            }else {
                if let error = error {
                    print (error)
                }
                completion(nil)
            
            }
            
        }
    }
    //function to retrieve user's name from db to display on user's profile
    func getUsername (completion: @escaping (_ name: String?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid //unwrap safetly in case user is not logged in
        else {
            completion(nil) //user is not logged in
            return
        }
        Firestore.firestore().collection("users").document(uid).getDocument { (docSnapshot, error) in
            if let doc = docSnapshot {
                if let name = doc.get("username") as? String {
                    completion(name) //success; return name
                } else {
                    print ("error getting field")
                    completion(nil)
                }
            }else {
                if let error = error {
                    print (error)
                }
                completion(nil)
            
            }
            
        }
    }
    //function to retrieve user's name from db to display on user's profile
    func getProfileImage (completion: @escaping (_ name: String?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid //unwrap safetly in case user is not logged in
        else {
            completion(nil) //user is not logged in
            return
        }
        Firestore.firestore().collection("users").document(uid).getDocument { (docSnapshot, error) in
            if let doc = docSnapshot {
                if let name = doc.get("profileImage") as? String {
                    completion(name) //success; return name
                } else {
                    print ("error getting field")
                    completion(nil)
                }
            }else {
                if let error = error {
                    print (error)
                }
                completion(nil)
            
            }
            
        }
    }
    
    
    @IBAction func homeToolbarButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "AccountToHomeSegue", sender: nil)
    }
    
    @IBAction func messageToolbarButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "AccountToMessageSegue", sender: nil)
    }
    @IBAction func notificationToolbarButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "AccountToNotifSegue", sender: nil)
    }
    @IBAction func settingsButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "AccountToSettingsSegue", sender: nil)
    }
    
    @IBAction func accountToolbarButtonTapped(_ sender: Any) {
        //do nothing already here
    }
    
    @IBAction func addListingButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "AccountToAddListingSegue", sender: nil)
    }
}
