//
//  CollectionViewCell.swift
//  IGApi1210
//
//  Created by change on 2021/12/10.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var collectionImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionImageView.layer.cornerRadius = 5
    }
}
