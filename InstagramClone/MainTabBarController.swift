//
//  MainTabBarController.swift
//  InstagramClone
//
//  Created by Konstantin Kostadinov on 10.05.19.
//  Copyright © 2019 Konstantin Kostadinov. All rights reserved.
//

import Foundation
import UIKit
import Firebase
class MainTabBarController: UITabBarController,UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = tabBarController.viewControllers?.firstIndex(of: viewController)
        if (index == 2){
            let layout = UICollectionViewFlowLayout()
            let photoSelectorController = PhotoSelectorController(collectionViewLayout: layout)
            let navController = UINavigationController(rootViewController: photoSelectorController)
            present(navController, animated: true, completion: nil )
            return false
        }
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        if Auth.auth().currentUser == nil{
            // show if user is not logged in
            DispatchQueue.main.async {
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController,animated: true,completion: nil)
            }
            
            return
        }
        setupViewControllers()
        
    }
    func setupViewControllers(){
        //home view
        let homeNavController = templateNavController(selectedImage: "home_selected", unselectedImage: "home_unselected",rootViewController: UserProfileController(collectionViewLayout: UICollectionViewFlowLayout()))
        //search view
        let searchNavController =  templateNavController(selectedImage: "search_selected", unselectedImage: "search_unselected")
        //plus view
        let plusNavController = templateNavController(selectedImage: "plus_selected", unselectedImage: "plus_unselected")
        //like View
        let likeNavController = templateNavController(selectedImage: "like_selected", unselectedImage: "like_unselected")
        //profile view
        let layout = UICollectionViewFlowLayout()
        let userProfileController =  UserProfileController(collectionViewLayout: layout)
        // CMD + CTRL + E = refactor
        let userProfileNavController = UINavigationController(rootViewController: userProfileController)
        
        userProfileNavController.tabBarItem.image = UIImage(named: "profile_unselected")
        userProfileNavController.tabBarItem.selectedImage = UIImage(named: "profile_selected")
        tabBar.tintColor = .black
        
        viewControllers = [homeNavController,searchNavController,plusNavController,likeNavController,userProfileNavController]
        
        //modify tabbar item insets
        guard let items = tabBar.items else{return}
        for item in items{
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4 , right: 0)
        }
    }
    fileprivate func templateNavController(selectedImage: String, unselectedImage: String, rootViewController: UIViewController = UIViewController()) -> UINavigationController{
        let viewController = rootViewController
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = UIImage(named: unselectedImage)
        navController.tabBarItem.selectedImage = UIImage(named: selectedImage)
        return navController
    }
}
