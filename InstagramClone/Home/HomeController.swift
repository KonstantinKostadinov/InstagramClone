//
//  HomeController.swift
//  InstagramClone
//
//  Created by Konstantin Kostadinov on 22.07.19.
//  Copyright © 2019 Konstantin Kostadinov. All rights reserved.
//

import UIKit
import Firebase
class HomeController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    let cellId = "cellId"
    var posts = [Post]()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
        setupNavigatoinItems()
        fetchPosts()
    }
    
    func setupNavigatoinItems(){
        navigationItem.titleView = UIImageView(image: UIImage(named: "logo2"))
    }
    
    fileprivate func fetchPosts(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference().child("posts").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String:Any] else {return}
            dictionaries.forEach({ (key,value) in
                guard let dictionary = value as? [String:Any] else {return}
                let post = Post(dictionary: dictionary)
                self.posts.append(post)
            })
            self.collectionView.reloadData()
        }) { (err) in
            print("Failed to fetch posts, ", err)
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 44 + 8 + 8 //userprofilepic username optionsbutton
        height += view.frame.width
        height += 50
        height += 60
        
        return CGSize(width: view.frame.width, height: height)
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostCell
        cell.post = posts[indexPath.item]
        return cell
    }
}
