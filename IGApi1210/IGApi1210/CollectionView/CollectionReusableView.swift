//
//  CollectionReusableView.swift
//  IGApi1210
//
//  Created by change on 2021/12/10.
//

import UIKit

class CollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var account: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var postCount: UILabel!
    @IBOutlet weak var followCount: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var textDescription: UITextView!
    
    @IBOutlet var buttons: [UIButton]!
    
    
}
