//
//  HomeViewController.swift
//  RealtyMe
//
//  Created by Kelly Walby on 2/2/21.
//  Copyright © 2021 Kelly Walby. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    @IBOutlet weak var homeToolbarButton: UIBarButtonItem!
    @IBOutlet weak var messageToolbarButton: UIBarButtonItem!
    @IBOutlet weak var notificationToolbarButton: UIBarButtonItem!
    @IBOutlet weak var accountToolbarButton: UIBarButtonItem!
    
    let db = Firestore.firestore()
    var listingArray = [String]()
    
    func loadData() {
        db.collection("listings").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    
                    self.listingArray.append(document.documentID)
                }
            }
            print(self.listingArray) // <-- This prints the adrress of listings aka document id
            self.collectionView.reloadData()

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:collectionView.frame.width/2.1, height: collectionView.frame.width/2)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listingArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
        //let user = usersArray[indexPath.row]
        //cell.textLabel?.text = user
        cell.backgroundColor = UIColor(red: 246/255.0, green: 246/255.0, blue: 246/255.0, alpha: 1) //super light gray
        cell.layer.cornerRadius = 8 //adds rounded corner to tiles
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "HomeToListingDetails", sender: nil)
    }
    
    
        fileprivate let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CustomCell.self, forCellWithReuseIdentifier: "cell")

        return cv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
        
        //setting up collection view colors & constraints
        view.addSubview(collectionView)
        collectionView.backgroundColor = .white
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        collectionView.showsVerticalScrollIndicator = false //makes scroll bar invisable

        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    @IBAction func homeToolbarButtonTapped(_ sender: Any) {
        //do nothing, already here
    }
    
    @IBAction func messageToolbarButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "HomeMessageSegue", sender: nil)
    }
    
    @IBAction func notificationToolbarButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "HomeToNotifSegue", sender: nil)
    }
    
    @IBAction func accountToolbarButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "HomeToAccountSegue", sender: nil)
    }
}

class CustomCell: UICollectionViewCell{
    
    func roundedCorners(corners:UIRectCorner, radius: CGFloat){
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    private let myImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "IMG_5797")
        imageView.tintColor = .black
        imageView.backgroundColor = .red
        return imageView
    }()
    
    private let myBookmark: UIButton = {
        let bookmark = UIButton()
        bookmark.setImage(UIImage(systemName: "bookmark"), for: .normal)
        bookmark.tintColor = .black
        return bookmark
    }()
    
    private let myLabel1: UILabel = {
        let addressLabel = UILabel()
        addressLabel.text = "Address"
        return addressLabel
    }()
    
    private let myLabel2: UILabel = {
        let priceLabel = UILabel()
        priceLabel.text = "Price"
        return priceLabel
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(myImageView)
        contentView.addSubview(myBookmark)
        contentView.addSubview(myLabel1)
        contentView.addSubview(myLabel2)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        myLabel1.frame = CGRect(x: 5,
                                y: contentView.frame.size.height-62.5,
                                width: contentView.frame.size.width-10,
                                height: 50)
        myLabel2.frame = CGRect(x: 5,
                                y: contentView.frame.size.height-40,
                                width: contentView.frame.size.width-10,
                                height: 50)
        myImageView.frame = CGRect(x: 0,
                                y: 0,
                                width: contentView.frame.size.width,
                                height: contentView.frame.size.height-50)
        myBookmark.frame = CGRect(x: 80,
                                y: contentView.frame.size.height-60,
                                width: contentView.frame.size.width-10,
                                height: 50)
        roundCorners(corners: [.topLeft, .topRight], radius: 8) //rounds the top two corners but not the bottom for image
    }
}

extension CustomCell {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
