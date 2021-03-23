//
//  AccountSettingsViewController.swift
//  RealtyMe
//
//  Created by Kelly Walby on 2/15/21.
//  Copyright © 2021 Kelly Walby. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class AccountSettingsViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var accountBioTextView: UITextView!
    @IBOutlet weak var profileName: UITextField!
    @IBOutlet weak var profileUsername: UITextField!
    @IBOutlet weak var profileEmail: UITextField!
    @IBOutlet weak var profilePhoneNumber: UITextField!
    @IBOutlet weak var profileZipcode: UITextField!
    @IBOutlet weak var saveAccountSettingsButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var picName: UITextField!
    
    private let storage = Storage.storage().reference()
    
    //variable to reference to db
    let db = Firestore.firestore()
    let uid = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //error label not showing
        
        errorLabel.alpha = 0
        picName.alpha = 0 //does not show name of pic
        
        //styling UI items
        Utilities.styleFilledButton(saveAccountSettingsButton)
        Utilities.styleTextField(profileName)
        Utilities.styleTextField(profileEmail)
        Utilities.styleTextField(profileZipcode)
        Utilities.styleTextField(profileUsername)
        Utilities.styleTextField(profilePhoneNumber)
        Utilities.styleTextView(accountBioTextView)
        
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.layer.cornerRadius = 60
        
        //profileImage?.image = UIImage(named: "IMG_5787")
        
        
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
        getProfileImageName { (imageName) in
            if let imageName = imageName {
                self.picName.text = imageName
            }
        }
        
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.contentMode = .scaleAspectFit
        profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        profileImage.isUserInteractionEnabled = true
        getProfileImage()
        
    }
    
    @objc func handleSelectProfileImageView(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: nil)
        guard let uid = Auth.auth().currentUser?.uid //unwrap safetly in case user is not logged in
        else {
            return //user is not logged in
        }
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        else {
            return
        }
        guard let imageData = image.pngData() else {
            return
        }
        let imageName = NSUUID().uuidString
        storage.child("userImages/\(imageName).png").putData(imageData, metadata: nil, completion: { _, error in
            guard error == nil else {
                print("failed to upload")
                return
            }
            self.storage.child("userImages/\(imageName).png").downloadURL (completion: {url, error in
                guard let url = url, error == nil else {
                    return
                }
                
                let urlString = url.absoluteString
                //update user data
                print("Download URL: \(urlString)")
                UserDefaults.standard.set(urlString, forKey: "url") //idk what this does
                let error = self.validateFields()
                self.picName.text = imageName+".png"
                if error != nil {
                    //Something wrong with the fields
                    self.showError(error!)
                }
                else {
                    //create cleaned versions of the data
                    let name = self.profileName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                    let username = self.profileUsername.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                    let email = self.profileEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                    let zipCode = self.profileZipcode.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                    let phoneNumber = self.profilePhoneNumber.text?.trimmingCharacters(in: .whitespacesAndNewlines) //optional
                    let bio = self.accountBioTextView.text.trimmingCharacters(in: .whitespacesAndNewlines) //optional
                     let picture = imageName+".png"
                    
                    
                    //update user's database and profile settings
                    let uid = Auth.auth().currentUser!.uid // safely unwrap the uid; avoid force unwrapping with !
                    let updateUserPic = self.db.collection("users").document(uid)
                    updateUserPic.setData(["name": name,"username":username,"email": email,"zipCode":zipCode,"phoneNumber":phoneNumber as Any,"bio":bio, "profileImage":picture]) {(error) in
                                if error != nil{
                                    self.showError("Error saving user data.")
                                }
                    }
                }
            })
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
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
    
    //function to retrieve user's name from db to display on user's profile
    func getProfileImage() {
        guard let uid = Auth.auth().currentUser?.uid //unwrap safetly in case user is not logged in
        else {
            return
        }
        Firestore.firestore().collection("users").document(uid).getDocument { (docSnapshot, error) in
            if let doc = docSnapshot {
                if let pic = doc.get("profileImage") as? String {
                    let reference = Storage.storage().reference(withPath: "userImages").child(pic)
                    // UIImageView in your ViewController
                    let imageView: UIImageView = self.profileImage
                    // Placeholder image
                    let placeholderImage = UIImage(named: "placeholder.jpg")
                    // Load the image using SDWebImage
                    imageView.sd_setImage(with: reference, placeholderImage: placeholderImage)
                } else {
                    print ("error getting field")
                }
            }else {
                if let error = error {
                    print (error)
                }
            
            }
            
        }
    }
    
    //function to retrieve user's name from db to display on user's profile
    func getProfileImageName(completion: @escaping (_ name: String?) -> Void) {
            guard let uid = Auth.auth().currentUser?.uid // safely unwrap the uid; avoid force unwrapping with !
            else{
                completion(nil) // user is not logged in; return nil
                return
            }
        Firestore.firestore().collection("users").document(uid).getDocument { (docSnapshot, error) in
                if let doc = docSnapshot {
                    if let name = doc.get("profileImage") as? String {
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
            let pic = picName.text?.trimmingCharacters(in: .whitespacesAndNewlines) //optional
                    
            //update user's database and profile settings
            let uid = Auth.auth().currentUser!.uid // safely unwrap the uid; avoid force unwrapping with !
            let updateUserInfo = db.collection("users").document(uid)
            updateUserInfo.setData(["name": name,"username":username,"email": email,"zipCode":zipCode,"phoneNumber":phoneNumber as Any,"bio":bio, "profileImage":pic as Any]) {(error) in
                        if error != nil{
                            self.showError("Error saving user data.")
                        }
                    }
            //create message to tell user their profile has been updated and save
            //showConfirmation("Your account settings were updated successfully!")
            self.dismiss(animated: true, completion: nil)
                }
                
            }
}
