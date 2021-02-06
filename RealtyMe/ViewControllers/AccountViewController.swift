//
//  AccountViewController.swift
//  RealtyMe
//
//  Created by Kelly Walby on 2/5/21.
//  Copyright © 2021 Kelly Walby. All rights reserved.
//

import UIKit
import Firebase




class AccountViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var profileName: UILabel!
    
    //reference to firestore db
    let db = Firestore.firestore()
    
    //current users iud which allows us to retrieve their data
    let id = Auth.auth().currentUser!.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
    }
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated) // call super
            
            getName { (name) in
                if let name = name {
                    self.profileName.text = name
                    self.profileName.alpha = 1 //shows message to user
                }
            }
    }
    
    func getName(completion: @escaping (_ name: String?) -> Void) {
            guard let uid = Auth.auth().currentUser?.uid // safely unwrap the uid; avoid force unwrapping with !
            else{
                completion(nil) // user is not logged in; return nil
                return
            }
            Firestore.firestore().collection("users").document("id").getDocument { (docSnapshot, error) in
                if let doc = docSnapshot {
                    if let name = doc.get("firstName") as? String {
                        completion(name) // success; return name
                    } else {
                        print("error getting field")
                        completion(nil) // error getting field; return nil
                    }
                } else {
                    if let error = error {
                        print(error)
                    }
                    completion(nil) // error getting document; return nil
                }
            }
        }
}

