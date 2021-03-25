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
    
    @IBOutlet weak var bookmarkButton: UIButton!
    let classHomeVC = HomeViewController()
    var isBookmarked = false
    var image: String = String()
    var address: String = String()
    var price: String = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //listingImage = classHomeVC.data.imageview
        listingAddress.text = address
        //listingStreetName.text = address
        listingPrice.text = "$"+price
        listingImage.image = UIImage(named: "IMG_5797")
        listingDescription.isEditable = false
        listingDescription.backgroundColor = UIColor(red: 246/255.0, green: 246/255.0, blue: 246/255.0, alpha: 1) //super light gray
        view.backgroundColor = UIColor(red: 246/255.0, green: 246/255.0, blue: 246/255.0, alpha: 1) //super light gray
        
        getCity { (city) in
            if let city = city {
                self.getZipcode { (zipcode) in
                    if let zipcode = zipcode {
                        self.getState { (state) in
                            if let state = state {
                                self.listingStreetName.text = city+", "+state+", "+zipcode
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
            }
        }
        getBedrooms { (bedrooms) in
            if let bedrooms = bedrooms {
                self.bedrooms.text = "Bedrooms: "+bedrooms
            }
        }
        getSqFt { (sqFt) in
            if let sqFt = sqFt {
                self.listingSqFt.text = "Square Feet: "+sqFt
            }
        }
//        bookmarkButton.setImage(btnImage, for: .normal)
//        bookmarkButton.setImage(btnImageFilled, for: .normal)
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
    
    func setOnEmptyBookmark(){
        isBookmarked = false
        let btnImage = UIImage(named: "bookmark")
        bookmarkButton.setImage(btnImage, for: .normal)
        
        
    }
    func setOnFilledBookmark(){
        isBookmarked = true
        let btnImageFilled = UIImage(named: "bookmark.fill")
        bookmarkButton.setImage(btnImageFilled, for: .normal)
        
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
    
    
    @IBAction func bookmarkButtonTapped(_ sender: AnyObject) {
        if !isBookmarked {
            isBookmarked = true
            setOnFilledBookmark()
        }else {
            setOnEmptyBookmark()
        }
    }
}
