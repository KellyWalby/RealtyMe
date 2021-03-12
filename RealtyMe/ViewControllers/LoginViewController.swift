//
//  LoginViewController.swift
//  RealtyMe
//
//  Created by Kelly Walby on 2/2/21.
//  Copyright © 2021 Kelly Walby. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    //outlets that connect UI to code
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var forgotPassButton: UIButton!
    
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
        Utilities.styleHollowButton(forgotPassButton)
        Utilities.styleFilledButton(loginButton)
        
        emailTextField.text = "walbs18@gmail.com" //DELETE, USING FOR EASY SIGN IN
        passwordTextField.text = "CoolKid1998!" //DELETE, USING FOR EASY SIGN IN
    }
    
    
    @IBAction func forgotPassButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "forgotPassSegue", sender: nil)
    }
    
    //checks to make sure info is correct
    func validateFields() -> String?{
        
        //checks that all fields are filled in
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields."
        }
        return nil
    }
    
    
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        //validate text fields
        let error = validateFields()
        
        if error != nil {
            //Something wrong with the fields
            self.showError(error!)
        } else {
            //create cleaned versions of text fields
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            //signing in user
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if error != nil{
                    //Couldnt sign in
                    self.showError(error!.localizedDescription) //see what localized description does
                } else {
                    self.performSegue(withIdentifier: "logInSegue", sender: nil)
                    //self.transitionToHome()
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
