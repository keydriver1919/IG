//
//  DetailTableViewController.swift
//  IGApi1210
//
//  Created by change on 2021/12/12.
//

import UIKit

class DetailTableViewController: UITableViewController {
  
    
    //貼文資訊
    let postInfo:InstagramResponse.Graphql.User.Edge_owner_to_timeline_media
    let indexPath:Int
    let userImageUrl:URL
    let userAcount:String
    
    init?(coder:NSCoder,userInfo:InstagramResponse, indexPath:Int ) {
        self.postInfo = userInfo.graphql.user.edge_owner_to_timeline_media
        self.indexPath = indexPath
        self.userImageUrl = userInfo.graphql.user.profile_pic_url
        self.userAcount = userInfo.graphql.user.username
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    var isShow = false
    override func viewDidLayoutSubviews() {
        if isShow == false{
            tableView.scrollToRow(at: IndexPath(item: indexPath, section: 0), at: .top, animated: true)
            isShow = true

        }
    }
    

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return postInfo.edges.count
    }

    //cell's content
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(DetailTableViewCell.self)", for: indexPath) as? DetailTableViewCell else { return UITableViewCell()}
        
        //fetch userImage
        URLSession.shared.dataTask(with: userImageUrl) { data, response, error in
            if let data = data {
                DispatchQueue.main.async {
                    cell.detailUserImage.layer.cornerRadius = cell.detailUserImage.frame.width/2
                    cell.detailUserImage.image = UIImage(data: data)
                    
                }
            }
        }.resume()
        
        //fetch PostImage ( specific [indexPath.row] )
        URLSession.shared.dataTask(with: postInfo.edges[indexPath.row].node.display_url) { data, response, error in
            if let data = data {
                DispatchQueue.main.async {
                    cell.detailImage.image = UIImage(data: data)
                    
                }
            }
        }.resume()
        
        // Configure the cell...
        //detailUserName.text = userAcount
        cell.detailUserName.text = userAcount
        cell.detailTextDescription?.text = postInfo.edges[indexPath.row].node.edge_media_to_caption.edges[0].node.text
        cell.detailLikeLabel.text = "Liked by john and \(postInfo.edges[indexPath.row].node.edge_liked_by.count) others."
        cell.detailCommentCount.text = "View all \(postInfo.edges[indexPath.row].node.edge_media_to_comment.count) comments."
        cell.detailDateLabel.text = dateFormate(date: postInfo.edges[indexPath.row].node.taken_at_timestamp)
        
        return cell
    }
    
    //日期時間轉換
    func dateFormate(date:Date)->String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale.current
        let dateString = formatter.string(from: date)
        
        return dateString
    }
}
