//
//  AccountViewController.swift
//  RealtyMe
//
//  Created by Kelly Walby on 3/12/21.
//  Copyright © 2021 Kelly Walby. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseUI

class AccountViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    struct BookmarkData {
        var listingArray = [String]() //listing addresses, also used to count how many listing are in db so that many cells are made
        var priceArray = [String]() //listing prices
        var imageArray = [String]() //listing image unique names (as in firebase storage)
        let imageview = UIImageView() //image for each cell
        let bookmark = UIButton() //bookmark icon for each cell
        let addressLabel = UILabel() //address label for each cell
        let priceLabel = UILabel() //price label for each cell
    }
    
    let uid = Auth.auth().currentUser!.uid
    var data = BookmarkData() //init of struct
    var selectedIndexPath: IndexPath = IndexPath()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.listingArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
        cell.backgroundColor = UIColor(red: 246/255.0, green: 246/255.0, blue: 246/255.0, alpha: 1) //super light gray
        cell.layer.cornerRadius = 8 //adds rounded corner to tiles
        if data.priceArray.count > 0 && indexPath.row < data.priceArray.count
            && data.imageArray.count > 0 && indexPath.row < data.imageArray.count {
            let address = data.listingArray[indexPath.row]
            cell.myLabel1.text = address
            let price = data.priceArray[indexPath.row]
            cell.myLabel2.text = "$"+price
            
            let image = data.imageArray[indexPath.row]
            let ref = Storage.storage().reference(withPath: "listingImages").child(image)
            let imageView: UIImageView = cell.myImageView
            let placeholderImage = UIImage (named: "placeholder.jpg")
            imageView.sd_setImage(with: ref,placeholderImage: placeholderImage)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:collectionView.frame.width/2.1, height: collectionView.frame.width/2)
    }
    
    
    
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
    @IBOutlet weak var bookmarksLabel: UILabel!
    
    let db = Firestore.firestore()
    
    fileprivate let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
    cv.translatesAutoresizingMaskIntoConstraints = false
    cv.register(CustomCell.self, forCellWithReuseIdentifier: "cell")

    return cv
    }()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = self.selectedIndexPath

        if (segue.identifier == "AccountToListingDetails") {
            let viewController = segue.destination as! listingDetailsViewController
            viewController.image = (data.imageArray[indexPath.row])
            viewController.address = (data.listingArray[indexPath.row])
            viewController.price = (data.priceArray[indexPath.row])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
        self.performSegue(withIdentifier: "AccountToListingDetails", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadBookmarkHouseAddress()
        loadBookmarkHousePrice()
        loadBookmarkHouseImage()
        
        //setting up collection view colors & constraints
        view.addSubview(collectionView)
        collectionView.backgroundColor = .white
        collectionView.topAnchor.constraint(equalTo: bookmarksLabel.bottomAnchor, constant: 10).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        collectionView.showsVerticalScrollIndicator = false //makes scroll bar invisable
        collectionView.delegate = self
        collectionView.dataSource = self
        
        bioTextView.isEditable = false
        Utilities.styleFilledButton(addListingButton)
        Utilities.styleTextView(bioTextView)
        
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
                self.username.text = "@" + username
            }
        }
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.layer.cornerRadius = 50
        getProfileImage()
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
    //function to retrieve user's profile image from db to display on user's profile
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
    
    func loadBookmarkHouseAddress() {
        db.collection("users").document(uid).collection("bookmarks").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.data.listingArray.append(document.documentID)
                }
            }
            self.collectionView.reloadData()

        }
    }
    
    func loadBookmarkHousePrice() {
        db.collection("users").document(uid).collection("bookmarks").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.data.priceArray.append(document.data()["price"] as! String)
                }
            }
            self.collectionView.reloadData()

        }
    }
    
    func loadBookmarkHouseImage() {
        db.collection("users").document(uid).collection("bookmarks").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.data.imageArray.append(document.data()["listingImage"] as! String)
                }
            }
            self.collectionView.reloadData()

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
