//
//  AccountSettingsViewController.swift
//  RealtyMe
//
//  Created by Kelly Walby on 2/15/21.
//  Copyright © 2021 Kelly Walby. All rights reserved.
//

import UIKit
import Firebase

class AccountSettingsViewController: UIViewController, UITextViewDelegate {
    
    
    @IBOutlet weak var accountBioTextView: UITextView!
    @IBOutlet weak var profileName: UITextField!
    @IBOutlet weak var profileUsername: UITextField!
    @IBOutlet weak var profileEmail: UITextField!
    @IBOutlet weak var profilePhoneNumber: UITextField!
    @IBOutlet weak var profileZipcode: UITextField!
    @IBOutlet weak var saveAccountSettingsButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var confirmationLabel: UILabel!
    
    //variable to reference to db
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //error label not showing
        
        errorLabel.alpha = 0
        confirmationLabel.alpha = 0
        
        //styling UI items
        Utilities.styleFilledButton(saveAccountSettingsButton)
        Utilities.styleTextField(profileName)
        Utilities.styleTextField(profileEmail)
        Utilities.styleTextField(profileZipcode)
        Utilities.styleTextField(profileUsername)
        Utilities.styleTextField(profilePhoneNumber)
        Utilities.styleTextView(accountBioTextView)
        
        getBio { (bio) in
            if let bio = bio {
                self.accountBioTextView.text = bio
            }
        }
        getName { (name) in
            if let name = name {
                self.profileName.text = name
            }
        }
        getEmail { (email) in
            if let email = email {
                self.profileEmail.text = email
            }
        }
        getZipcode { (zipcode) in
            if let zipcode = zipcode {
                self.profileZipcode.text = zipcode
            }
        }
        getPhoneNumber { (phoneNumber) in
            if let phoneNumber = phoneNumber{
                self.profilePhoneNumber.text = phoneNumber
            }
        }
        getUsername { (username) in
            if let username = username {
                self.profileUsername.text = username
            }
        }
        
    }
    
    //function to retrieve user's bio from db to display on user's profile
    func getBio(completion: @escaping (_ name: String?) -> Void) {
            guard let uid = Auth.auth().currentUser?.uid // safely unwrap the uid; avoid force unwrapping with !
            else{
                completion(nil) // user is not logged in; return nil
                return
            }
        Firestore.firestore().collection("users").document(uid).getDocument { (docSnapshot, error) in
                if let doc = docSnapshot {
                    if let name = doc.get("bio") as? String {
                        completion(name) // success; return name
                    } else {
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
    
    //function to retrieve user's name from db to display on user's profile
    func getName(completion: @escaping (_ name: String?) -> Void) {
            guard let uid = Auth.auth().currentUser?.uid // safely unwrap the uid; avoid force unwrapping with !
            else{
                completion(nil) // user is not logged in; return nil
                return
            }
        Firestore.firestore().collection("users").document(uid).getDocument { (docSnapshot, error) in
                if let doc = docSnapshot {
                    if let name = doc.get("name") as? String {
                        completion(name) // success; return name
                    } else {
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
    
    //function to retrieve user's email from db to display on user's profile
    func getEmail(completion: @escaping (_ name: String?) -> Void) {
            guard let uid = Auth.auth().currentUser?.uid // safely unwrap the uid; avoid force unwrapping with !
            else{
                completion(nil) // user is not logged in; return nil
                return
            }
        Firestore.firestore().collection("users").document(uid).getDocument { (docSnapshot, error) in
                if let doc = docSnapshot {
                    if let name = doc.get("email") as? String {
                        completion(name) // success; return name
                    } else {
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
    
    //function to retrieve user's email from db to display on user's profile
    func getZipcode(completion: @escaping (_ name: String?) -> Void) {
            guard let uid = Auth.auth().currentUser?.uid // safely unwrap the uid; avoid force unwrapping with !
            else{
                completion(nil) // user is not logged in; return nil
                return
            }
        Firestore.firestore().collection("users").document(uid).getDocument { (docSnapshot, error) in
                if let doc = docSnapshot {
                    if let name = doc.get("zipCode") as? String {
                        completion(name) // success; return name
                    } else {
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
    
    //function to retrieve user's email from db to display on user's profile
    func getPhoneNumber(completion: @escaping (_ name: String?) -> Void) {
            guard let uid = Auth.auth().currentUser?.uid // safely unwrap the uid; avoid force unwrapping with !
            else{
                completion(nil) // user is not logged in; return nil
                return
            }
        Firestore.firestore().collection("users").document(uid).getDocument { (docSnapshot, error) in
                if let doc = docSnapshot {
                    if let name = doc.get("phoneNumber") as? String {
                        completion(name) // success; return name
                    } else {
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
    
    //function to retrieve user's email from db to display on user's profile
    func getUsername(completion: @escaping (_ name: String?) -> Void) {
            guard let uid = Auth.auth().currentUser?.uid // safely unwrap the uid; avoid force unwrapping with !
            else{
                completion(nil) // user is not logged in; return nil
                return
            }
        Firestore.firestore().collection("users").document(uid).getDocument { (docSnapshot, error) in
                if let doc = docSnapshot {
                    if let name = doc.get("username") as? String {
                        completion(name) // success; return name
                    } else {
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
    
    func showError(_ message:String){
        errorLabel.text = message //creates error message
        errorLabel.alpha = 1 //shows message to user
}
    func showConfirmation(_ message:String){
        confirmationLabel.text = message //creates error message
        confirmationLabel.alpha = 1 //shows message to user
}
    
    //checks to make sure info is correct
    func validateFields() -> String?{
        
        //checks that all fields are filled in
        if profileName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || profileEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || profileUsername.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || profileZipcode.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields."
        }
        //check if password is secure
        //let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //returns a bool if password is secure or not
        //if false, password does not meet requirements
//        if Utilities.isPasswordValid(cleanedPassword) == false {
//            //Password is not secure
//            return "Please make sure your password is at least 8 characters, contains a special character and a number."
//        }
//
        
        return nil
    }
    
    //updates users profile information in the app and in the db
    @IBAction func saveAccountSettingsButtonTapped(_ sender: Any) {
        //validate the fields
        let error = validateFields()
        
        if error != nil {
            //Something wrong with the fields
            showError(error!)
        }
        else {
            //create cleaned versions of the data
            let name = profileName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let username = profileUsername.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = profileEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let zipCode = profileZipcode.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let phoneNumber = profilePhoneNumber.text?.trimmingCharacters(in: .whitespacesAndNewlines) //optional
            let bio = accountBioTextView.text.trimmingCharacters(in: .whitespacesAndNewlines) //optional
            
            
            //update user's database and profile settings
            let uid = Auth.auth().currentUser!.uid // safely unwrap the uid; avoid force unwrapping with !
            let updateUserInfo = db.collection("users").document(uid)
            updateUserInfo.setData(["name": name,"username":username,"email": email,"zipCode":zipCode,"phoneNumber":phoneNumber,"bio":bio]) {(error) in
                        if error != nil{
                            self.showError("Error saving user data.")
                        }
                    }
            //create message to tell user their profile has been updated and save
            showConfirmation("Your account settings were updated successfully!")
                }
                
            }
}
