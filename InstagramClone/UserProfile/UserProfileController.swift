//
//  UserProfileController.swift
//  InstagramClone
//
//  Created by Konstantin Kostadinov on 10.05.19.
//  Copyright © 2019 Konstantin Kostadinov. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UserProfileHeaderDelegate {
    
    let cellId = "cellId"
    let headerId = "headerId"
    let homePostCellId = "homePostCellId"
    var userId: String?
    var isGridView:Bool = true
    
    func didChangeToGridView() {
        isGridView = true
        collectionView.reloadData()

    }
    
    func didChangeToListView() {
        isGridView = false
        collectionView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        
        //navigationItem.title = Auth.auth().currentUser?.uid
        
        
        
        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView?.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: homePostCellId)
        setupLogOutButton()
        fetchUser()
        //fetchOrderedPosts()
    }
    var posts = [Post]()
    fileprivate func fetchOrderedPosts(){
        guard let uid = self.user?.uid else {return}
        let ref = Database.database().reference().child("posts").child(uid)
        ref.queryOrdered(byChild: "creationDate").observe(.childAdded, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String:Any] else {return}
            guard let user = self.user else {return}
            let post = Post(user: user,dictionary: dictionary)
            self.posts.insert(post, at: 0)
            self.collectionView.reloadData()
        }) { (err) in
            print("failed to fetch ordered posts: ", err)
        }
    }
    
    fileprivate func setupLogOutButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "gear")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action:  #selector(handleLogOut))
    }
    @objc func handleLogOut(){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            do{
                try Auth.auth().signOut()
                let loginController = LoginController()
                let navController  = UINavigationController(rootViewController: loginController)
                self.present(navController, animated: true, completion: nil)
                
            }catch let signOutErr{
                print("Sign out error ", signOutErr)
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isGridView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserProfilePhotoCell
            cell.post = posts[indexPath.item]
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homePostCellId, for: indexPath) as! HomePostCell
            cell.post = posts[indexPath.item]
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if isGridView {
            let width = (view.frame.width-2)/3
            let height = width
            return CGSize(width: width, height: height)
        } else {
            var height: CGFloat = 44 + 8 + 8 //userprofilepic username optionsbutton
            height += view.frame.width
            height += 50 // like,comment...
            height += 60 // caption
            return CGSize(width: view.frame.width, height: height)
        }
        
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! UserProfileHeader
        
        header.user = self.user
        header.delegate = self
        
        //not correct
        //header.addSubview(UIImageView())
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    var user: User?
    fileprivate func fetchUser() {
        let uid = userId ?? Auth.auth().currentUser?.uid ?? ""
        //guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.fetchingUserWithUID(uid: uid) { (user) in
            self.user = user
            self.navigationItem.title = self.user?.username
            
            self.collectionView?.reloadData()
            self.fetchOrderedPosts()
        }
    }
    
}







