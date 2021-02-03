//
//  SignUpViewController.swift
//  RealtyMe
//
//  Created by Kelly Walby on 2/2/21.
//  Copyright © 2021 Kelly Walby. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {

    //outlets that connect UI to code
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var zipcodeTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //calls function to syle UI
        setUpElements()
    }
    
    //function for styling UI elements
    func setUpElements(){
        
        //hides error label initially
        errorLabel.alpha = 0
        
        //styling elements
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(zipcodeTextField)
        
        Utilities.styleFilledButton(signUpButton)
    }
    

    
    //checks to make sure info is correct
    func validateFields() -> String?{
        
        //checks that all fields are filled in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || zipcodeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields."
        }
        //check if password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //returns a bool if password is secure or not
        //if false, password does not meet requirements
        if Utilities.isPasswordValid(cleanedPassword) == false {
            //Password is not secure
            return "Please make sure your password is at least 8 characters, contains a special character and a number."
        }
        
        
        return nil
    }
    
    
    @IBAction func signUpTapped(_ sender: Any) {
        //validate the fields
        let error = validateFields()
        
        if error != nil {
            //Something wrong with the fields
            showError(error!)
        }
        else {
            //create cleaned versions of the data
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let zipCode = zipcodeTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            
            //create user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                //check for errors
                if err != nil{
                    //Error creating user
                    self.showError("Error creating user.")
                }
                else {
                    //user was created successfully, now store information
                    let db = Firestore.firestore()
                    
                    db.collection("users").addDocument(data: ["firstName":firstName,"lastName":lastName,"zipCode":zipCode, "uid":result!.user.uid]) { (error) in
                        
                        if error != nil{
                            self.showError("Error saving user data.")
                        }
                    }
                    //transition to home screen
                    self.transitionToHome()
                    
                }
                
            }
            
        }
        
        
    }
    func showError(_ message:String){
        errorLabel.text = message //creates error message
        errorLabel.alpha = 1 //shows message to user
        
}
    func transitionToHome(){
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    
}
