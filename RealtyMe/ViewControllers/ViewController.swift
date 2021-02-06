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
    
    //outlets that connect UI to code
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var LogInButton: UIButton!
    @IBOutlet weak var GoogleSignInButton: GIDSignInButton!
    
    //variable to reference to db
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        //calls function to style UI
        setUpElements()
    }
    
    //function for styling UI elements
    func setUpElements(){
        
        //styling elements
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleHollowButton(LogInButton)
    }
    

    //maybe so they can move onto the home screen??
    @IBAction func GoogleSignInButtonTapped(_ sender: Any) {
        //check if google user has account. If yes, transition to home screen
        transitionToHome()
        //if not, transition to create account then transition to home screen
}
    
func transitionToHome(){
    let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
    
    view.window?.rootViewController = homeViewController
    view.window?.makeKeyAndVisible()
        }
    
}

