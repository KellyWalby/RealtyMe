//
//  HomeViewController.swift
//  RealtyMe
//
//  Created by Kelly Walby on 2/2/21.
//  Copyright © 2021 Kelly Walby. All rights reserved.
//

import UIKit
import Firebase

//struct listingData {
//    var listingArray = [String]()
//}

class HomeViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    struct houseData {
        var listingArray = [String]() //listing addresses, also used to count how many listing are in db so that many cells are made
        var priceArray = [String]() //listing prices
        var imageArray = [String]() //listing image unique names (as in firebase storage)
        let imageview = UIImageView() //image for each cell
        let bookmark = UIButton() //bookmark icon for each cell
        let addressLabel = UILabel() //address label for each cell
        let priceLabel = UILabel() //price label for each cell
    }
    var data = houseData() //init of struct
    var selectedIndexPath: IndexPath = IndexPath()
    
    
    @IBOutlet weak var homeToolbarButton: UIBarButtonItem!
    @IBOutlet weak var messageToolbarButton: UIBarButtonItem!
    @IBOutlet weak var accountToolbarButton: UIBarButtonItem!
    
    let db = Firestore.firestore()
    
    func loadHouseAddress() {
        db.collection("listings").getDocuments() { (querySnapshot, err) in
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
    
    func loadHousePrice() {
        db.collection("listings").getDocuments() { (querySnapshot, err) in
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
    
    func loadHouseImage() {
        db.collection("listings").getDocuments() { (querySnapshot, err) in
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:collectionView.frame.width/2.1, height: collectionView.frame.width/2)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.listingArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
        cell.backgroundColor = UIColor(red: 246/255.0, green: 246/255.0, blue: 246/255.0, alpha: 1) //super light gray
        cell.layer.cornerRadius = 8 //adds rounded corner to tiles
        //this makes sure that the price array is above 0
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = self.selectedIndexPath

        if (segue.identifier == "HomeToListingDetails") {
            let viewController = segue.destination as! listingDetailsViewController
            viewController.image = (data.imageArray[indexPath.row])
            viewController.address = (data.listingArray[indexPath.row])
            viewController.price = (data.priceArray[indexPath.row])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
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
        loadHouseAddress()
        loadHousePrice()
        loadHouseImage()

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
    
    @IBAction func accountToolbarButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "HomeToAccountSegue", sender: nil)
    }
}

class CustomCell: UICollectionViewCell{
    
    public let myImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .black
        imageView.backgroundColor = UIColor(red: 246/255.0, green: 246/255.0, blue: 246/255.0, alpha: 1) //super light gray
        return imageView
    }()
    
    public let myBookmark: UIButton = {
        let bookmark = UIButton()
        bookmark.setImage(UIImage(systemName: "bookmark"), for: .normal)
        bookmark.tintColor = UIColor(red: 156/255.0, green: 28/255.0, blue: 35/255.0, alpha: 1) //super light gray
        return bookmark
    }()
    
    public let myLabel1: UILabel = {
        let addressLabel = UILabel()
        return addressLabel
    }()
    
    public  let myLabel2: UILabel = {
        let priceLabel = UILabel()
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
