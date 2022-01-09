//
//  CollectionViewController.swift
//  IGApi1210
//
//  Created by change on 2021/12/10.
//
import UIKit

private let reuseIdentifier = "\(CollectionViewCell.self)"

let fullSize = UIScreen.main.bounds.size

class CollectionViewController: UICollectionViewController {
    var userInfo:InstagramResponse?
    var postImages = [InstagramResponse.Graphql.User.Edge_owner_to_timeline_media.Edges]()
    
    func configureCellSize() {
            let itemSpace: CGFloat = 3
            let columnCount: CGFloat = 3
            
            let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout
        
            let width = floor((collectionView.bounds.width - itemSpace * (columnCount-1)) / columnCount)
            flowLayout?.itemSize = CGSize(width: width, height: width)
            
            flowLayout?.estimatedItemSize = .zero
            flowLayout?.minimumInteritemSpacing = itemSpace
            flowLayout?.minimumLineSpacing = itemSpace
            
    }
    
    
    func fetchData() {
        let urlStr = "https://www.instagram.com/mikanqtarosan/?__a=1"
        if let url = URL(string: urlStr) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                
                if let data = data {
                    do {
                        let searchResponse = try decoder.decode(InstagramResponse.self, from: data)
                        self.userInfo = searchResponse
                        DispatchQueue.main.async {
                            self.postImages = (self.userInfo?.graphql.user.edge_owner_to_timeline_media.edges)!
                            self.collectionView.reloadData()
                           
                        }
                    } catch {
                        print(error)
                    }
                    
                }
            }.resume()
        }
        
    }
    
    @IBSegueAction func showDetail(_ coder: NSCoder) -> DetailTableViewController? {
        guard let row = collectionView.indexPathsForSelectedItems?.first?.row else { return nil }
        return DetailTableViewController(coder: coder, userInfo: userInfo!, indexPath: row)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        
        configureCellSize()
       
    }

  
    
    
 

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postImages.count
    }
    
    //posts cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(CollectionViewCell.self)", for: indexPath) as? CollectionViewCell else {return UICollectionViewCell()}
        
        let item = postImages[indexPath.item]
        //fetch Images (PhotoWall)
        URLSession.shared.dataTask(with: item.node.display_url) { data, response, error in
            if let data = data {
                DispatchQueue.main.async {
                    cell.collectionImageView.image = UIImage(data: data)
                }
            }
        }.resume()
        
        // Configure the cell
    
        return cell
    }
    
    
    //設定Header的內容
    //userInfo reusableView
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        //ReusableView的ofKind設定為Header, ID對象是userInfo的reusableView, as轉型為自訂reusableView型別
        guard let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(CollectionReusableView.self)", for: indexPath) as? CollectionReusableView else { return UICollectionReusableView() }
        
        //fetch 使用者資料
        if let userImageUrl = userInfo?.graphql.user.profile_pic_url {
            URLSession.shared.dataTask(with: userImageUrl) { data, response, error in
                if let data = data {
                    do {
                        DispatchQueue.main.async {
                            reusableView.userImage.layer.cornerRadius = reusableView.userImage.frame.width/2
                            reusableView.userImage.image = UIImage(data: data)
                        }
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        }
        //代入欲顯示資料之對應元件
        if let postCount = userInfo?.graphql.user.edge_owner_to_timeline_media.count,
           let followersCount = userInfo?.graphql.user.edge_followed_by.count,
           let followingCount = userInfo?.graphql.user.edge_follow.count,
           let userName = userInfo?.graphql.user.full_name,
           let userAcount = userInfo?.graphql.user.username,
           let category = userInfo?.graphql.user.category_name,
           let bio = userInfo?.graphql.user.biography {
            
            reusableView.postCount.text = String(postCount)
            reusableView.followCount.text = String(followersCount)
            reusableView.followingCount.text = String(followingCount)
            reusableView.userName.text = userName
            reusableView.account.text = userAcount
            reusableView.category.text = category
            reusableView.textDescription.text = bio
            
            for i in reusableView.buttons {
                i.layer.borderWidth = 1
                i.layer.cornerRadius = 3
                i.layer.borderColor = UIColor(red: 218/255, green: 219/255, blue: 218/255, alpha: 1).cgColor
            }
            
        }
        
        return reusableView
    }
    
    
    
}

