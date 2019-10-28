//
//  HomeController.swift
//  InstagramClone
//
//  Created by Konstantin Kostadinov on 22.07.19.
//  Copyright © 2019 Konstantin Kostadinov. All rights reserved.
//

import UIKit
import Firebase
class HomeController: UICollectionViewController,UICollectionViewDelegateFlowLayout, HomePostCellDelegate {
    let cellId = "cellId"
    var posts = [Post]()
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name:         SharePhotoController.updateFeedNotificationName, object: nil)
        collectionView.backgroundColor = .white
        collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        setupNavigatoinItems()
        fetchAllPost()
        
    }
    @objc func handleUpdateFeed(){
        handleRefresh()
    }
    @objc func handleRefresh(){
        posts.removeAll()
        collectionView.reloadData()
        fetchAllPost()
    }
    fileprivate func fetchAllPost(){
        fetchPosts()
        fetchFollowingUserIds()
    }
    fileprivate func fetchFollowingUserIds(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("following").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userIdsDictionaries = snapshot.value as? [String:Any] else {return}
            userIdsDictionaries.forEach({ (key,value) in
                Database.fetchingUserWithUID(uid: key, completion: { (user) in
                    self.fetchPostWithUser(user: user)
                })
            })
        }) { (err) in
            print("Failed to fetch following user ids: ",err)
        }
    }
    func setupNavigatoinItems(){
        navigationItem.titleView = UIImageView(image: UIImage(named: "logo2"))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "camera3")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleCamera))
    }
    
    @objc func handleCamera(){
        let cameraController = CameraController()
        present(cameraController, animated: true, completion: nil)
    }
    fileprivate func fetchPosts(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.fetchingUserWithUID(uid: uid) { (user) in
            self.fetchPostWithUser(user: user)
        }
    }
    fileprivate func fetchPostWithUser(user: User){
        let ref = Database.database().reference().child("posts").child(user.uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            self.collectionView.refreshControl?.endRefreshing()
            guard let dictionaries = snapshot.value as? [String:Any] else {return}
            dictionaries.forEach({ (key,value) in
                guard let dictionary = value as? [String:Any] else {return}
                var post = Post(user: user,dictionary: dictionary)
                post.id = key
                guard let uid = Auth.auth().currentUser?.uid else {return}
                Database.database().reference().child("likes").child(key).child(uid).observeSingleEvent(of: .value
                    , with: { (snapshot) in
                        if let value = snapshot.value as? Int, value == 1{
                            post.hasLiked = true
                        } else {
                            post.hasLiked = false
                        }
                        self.posts.append(post)
                        self.posts.sort(by: { (p1, p2) -> Bool in
                            return p1.creationDate.compare(p2.creationDate) == .orderedDescending
                        })
                        self.collectionView.reloadData()
                }, withCancel: { (err) in
                        print("Failed to fetch like info for post: ",err)
                })
            })
        }) { (err) in
            print("Failed to fetch posts, ", err)
        }
    }
    
    func collectionView(_ collecwtionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 44 + 8 + 8 //userprofilepic username optionsbutton
        height += view.frame.width
        height += 50 // like,comment...
        height += 60 // caption
        
        return CGSize(width: view.frame.width, height: height)
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostCell
        cell.post = posts[indexPath.item]
        cell.delegate = self
        return cell
    }
    func didTapComment(post: Post) {
        print(post.caption)
        let commentsController = CommentsController(collectionViewLayout: UICollectionViewFlowLayout())
        commentsController.post = post
        navigationController?.pushViewController(commentsController, animated: true)
    }
    func didLike(for cell: HomePostCell) {
        print("Handling Like inside of the controller")
        guard let indexPath = collectionView.indexPath(for: cell) else {return}
        var post = self.posts[indexPath.item]
        print(post.caption)
        guard let postId = post.id else {return}
        guard let uid = Auth.auth().currentUser?.uid else{return}
        let values = [uid: post.hasLiked == true ? 0 : 1]
        Database.database().reference().child("likes").child(postId).updateChildValues(values) { (err, _) in
            if let err = err{
                print("Failed to like post: ",err)
                return
            }
            print("successfully liked post")
            post.hasLiked = !post.hasLiked
            self.posts[indexPath.item] = post
            self.collectionView.reloadItems(at: [indexPath])
        }
    }
}
