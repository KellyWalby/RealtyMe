//
//  listingDetailsViewController.swift
//  RealtyMe
//
//  Created by Kelly Walby on 3/23/21.
//  Copyright © 2021 Kelly Walby. All rights reserved.
//

import UIKit
import Firebase

class listingDetailsViewController: UIViewController {
    
    
    @IBOutlet weak var homeToolbarButton: UIBarButtonItem!
    @IBOutlet weak var messageToolbarButton: UIBarButtonItem!
    @IBOutlet weak var notificationToolbarButton: UIBarButtonItem!
    @IBOutlet weak var accountToolbarButton: UIBarButtonItem!
    
    @IBOutlet weak var listingImage: UIImageView!
    @IBOutlet weak var listingStreetName: UILabel!
    @IBOutlet weak var listingAddress: UILabel!
    @IBOutlet weak var listingPrice: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var listingSqFt: UILabel!
    @IBOutlet weak var listingFeatures: UILabel!
    @IBOutlet weak var listingDescription: UITextView!
    @IBOutlet weak var bedrooms: UILabel!
    @IBOutlet weak var bathrooms: UILabel!
    
    private var animatedView: UIView?
    let db = Firestore.firestore()
    let uid = Auth.auth().currentUser?.uid
    
    let classHomeVC = HomeViewController()
    let classAccountVC = AccountViewController()
    var image: String = String()
    var address: String = String()
    var price: String = String()
    var globalCity = ""
    var globalState = ""
    var globalZipcode = ""
    var globalPrice = ""
    var globalBathrooms = ""
    var globalBedrooms = ""
    var globalSqFt = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listingAddress.text = address
        listingPrice.text = "$"+price
        globalPrice = price
        listingDescription.isEditable = false
        listingDescription.isScrollEnabled = false
        listingDescription.backgroundColor = UIColor(red: 246/255.0, green: 246/255.0, blue: 246/255.0, alpha: 1) //super light gray
        view.backgroundColor = UIColor(red: 246/255.0, green: 246/255.0, blue: 246/255.0, alpha: 1) //super light gray
        
        getCity { (city) in
            if let city = city {
                self.getZipcode { (zipcode) in
                    if let zipcode = zipcode {
                        self.getState { (state) in
                            if let state = state {
                                self.listingStreetName.text = city+", "+state+", "+zipcode
                                self.globalCity = city
                                self.globalState = state
                                self.globalZipcode = zipcode
                            }
                        }
                //self.picName.text = imageName
                    }
                }
            }
        }
        getImage()
        
        getDescription { (description) in
            if let description = description {
                self.listingDescription.text = description
            }
        }
        getBathrooms { (bathrooms) in
            if let bathrooms = bathrooms {
                self.bathrooms.text = "Bathrooms: "+bathrooms
                self.globalBathrooms = bathrooms
            }
        }
        getBedrooms { (bedrooms) in
            if let bedrooms = bedrooms {
                self.bedrooms.text = "Bedrooms: "+bedrooms
                self.globalBedrooms = bedrooms
            }
        }
        getSqFt { (sqFt) in
            if let sqFt = sqFt {
                self.listingSqFt.text = "Square Feet: "+sqFt
                self.globalSqFt = sqFt
            }
        }
        let buttonFrame = CGRect(x: view.frame.midX + 140, y: view.frame.midY + 12.5, width: 70, height: 70)
            let heartButton = BookmarkButton(frame: buttonFrame)
            heartButton.addTarget(
              self, action: #selector(handleHeartButtonTap(_:)), for: .touchUpInside)
            view.addSubview(heartButton)
    }
    
    //function to retrieve user's name from db to display on user's profile
    func getCity (completion: @escaping (_ name: String?) -> Void) {
        Firestore.firestore().collection("listings").document(address).getDocument { (docSnapshot, error) in
            if let doc = docSnapshot {
                if let name = doc.get("city") as? String {
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
    func getState (completion: @escaping (_ name: String?) -> Void) {
        Firestore.firestore().collection("listings").document(address).getDocument { (docSnapshot, error) in
            if let doc = docSnapshot {
                if let name = doc.get("state") as? String {
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
    func getZipcode (completion: @escaping (_ name: String?) -> Void) {
        Firestore.firestore().collection("listings").document(address).getDocument { (docSnapshot, error) in
            if let doc = docSnapshot {
                if let name = doc.get("zipcode") as? String {
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
    
    func getImage(){
        let ref = Storage.storage().reference(withPath: "listingImages").child(image)
        let imageView: UIImageView = listingImage
        let placeholderImage = UIImage (named: "placeholder.jpg")
        imageView.sd_setImage(with: ref,placeholderImage: placeholderImage)
    }
    
    //function to retrieve user's name from db to display on user's profile
    func getDescription (completion: @escaping (_ name: String?) -> Void) {
        Firestore.firestore().collection("listings").document(address).getDocument { (docSnapshot, error) in
            if let doc = docSnapshot {
                if let name = doc.get("description") as? String {
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
    func getBathrooms (completion: @escaping (_ name: String?) -> Void) {
        Firestore.firestore().collection("listings").document(address).getDocument { (docSnapshot, error) in
            if let doc = docSnapshot {
                if let name = doc.get("bathrooms") as? String {
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
    func getBedrooms (completion: @escaping (_ name: String?) -> Void) {
        Firestore.firestore().collection("listings").document(address).getDocument { (docSnapshot, error) in
            if let doc = docSnapshot {
                if let name = doc.get("bedrooms") as? String {
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
    func getSqFt (completion: @escaping (_ name: String?) -> Void) {
        Firestore.firestore().collection("listings").document(address).getDocument { (docSnapshot, error) in
            if let doc = docSnapshot {
                if let name = doc.get("sqFt") as? String {
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
    
    @objc private func handleHeartButtonTap(_ sender: UIButton) {
      guard let button = sender as? BookmarkButton else
      {
        return
      }
      button.flipLikedState()
        if button.isLiked == true {
            //create cleaned versions of the data
            let price = globalPrice
            let address = listingAddress.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let city = globalCity
            let state = globalState
            let zipcode = globalZipcode
            let sqFt = globalSqFt
            let bathrooms = globalBathrooms
            let bedrooms = globalBedrooms
            let description = listingDescription.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                
            //create new listing
            let createBookmark = db.collection("users").document(uid!).collection("bookmarks").document(address)
            createBookmark.setData(["price": price,
                                   "address":address,
                                   "city":city,
                                   "state":state,
                                   "zipcode":zipcode,
                                   "sqFt":sqFt,
                                   "bathrooms":bathrooms,
                                   "bedrooms":bedrooms,
                                   "description":description,
                                   "listingImage":image])
            {(error) in
                            if error != nil{
                                print("Error saving user data.")
                            }
                        }
        } else if button.isLiked == false {
            //delete bookmark here
            db.collection("users").document(uid!).collection("bookmarks").document(address).delete() { err in
                if let err = err {
                    //print("Error removing document: \(err)")
                } else {
                    //print("Document successfully removed!")
                }
            }
        }
    }
    
    @IBAction func homeToolbarButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "ListingDetailsToHome", sender: nil)
    }
    
    @IBAction func messageToolbarButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "ListingDetailsToMessage", sender: nil)
    }
    
    @IBAction func notificationToolbarButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "ListingDetailsToNotif", sender: nil)
    }
    @IBAction func accountToolbarButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "ListingDetailsToAccount", sender: nil)
    }
    
    
}
