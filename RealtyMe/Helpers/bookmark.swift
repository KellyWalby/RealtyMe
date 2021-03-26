//
//  Bookmark.swift
//  RealtyMe
//
//  Created by Kelly Walby on 3/26/21.
//  Copyright © 2021 Kelly Walby. All rights reserved.
//

import Foundation
import UIKit

class BookmarkButton: UIButton {
    
    public var isLiked = false
    
    private let unlikedImage = UIImage(named: "unliked_bookmark")
    private let likedImage = UIImage(named: "liked_bookmark")
    
    private let unlikedScale: CGFloat = 0.7
    private let likedScale: CGFloat = 1.3

    override public init(frame: CGRect) {
      super.init(frame: frame)

      setImage(unlikedImage, for: .normal)
    }
    
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    public func flipLikedState() {
      isLiked = !isLiked
      animate()
    }

    private func animate() {
      UIView.animate(withDuration: 0.1, animations: {
        let newImage = self.isLiked ? self.likedImage : self.unlikedImage
        let newScale = self.isLiked ? self.likedScale : self.unlikedScale
        self.transform = self.transform.scaledBy(x: newScale, y: newScale)
        self.setImage(newImage, for: .normal)
      }, completion: { _ in
        UIView.animate(withDuration: 0.1, animations: {
          self.transform = CGAffineTransform.identity
        })
      })
    }
}
