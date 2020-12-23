//
//  CollectionViewCell.swift
//  Meal Recipes
//
//  Created by Stas on 11.12.2020.
//

import UIKit
import SDWebImage

class CollectionViewCell: UICollectionViewCell {
   
    @IBOutlet weak var standImage: UIImageView!
    var imageURL: URL?{
        didSet{
            //print(imageURL)
            self.standImage.sd_setImage(with: imageURL)
        }
    }
}
