//
//  DetailTableViewCell.swift
//  IGApi1210
//
//  Created by change on 2021/12/12.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    @IBOutlet weak var detailUserImage: UIImageView!
    @IBOutlet weak var detailUserName: UILabel!
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var detailLikeButton: UIButton!
    @IBOutlet weak var detailLikeLabel: UILabel!
    @IBOutlet weak var detailTextDescription: UITextView!
    @IBOutlet weak var detailCommentCount: UILabel!
    @IBOutlet weak var detailDateLabel: UILabel!
    
    
    
    var isLiked = false
    func setLikeBtn() {
        if isLiked {
            detailLikeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            isLiked = false
        }else{
            detailLikeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            isLiked = true
        }
    }
    
    @IBAction func detailLikeButtonAction(_ sender: Any) {
        setLikeBtn()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
