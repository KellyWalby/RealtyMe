//
//  ViewController.swift
//  RealtyMe
//
//  Created by Kelly Walby on 1/12/21.
//  Copyright © 2021 Kelly Walby. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import GoogleSignIn



class ViewController: UIViewController {
    
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }

}

