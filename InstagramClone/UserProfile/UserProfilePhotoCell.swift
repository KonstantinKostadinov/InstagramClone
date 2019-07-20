//
//  UserProfilePhotoCell.swift
//  InstagramClone
//
//  Created by Konstantin Kostadinov on 20.07.19.
//  Copyright © 2019 Konstantin Kostadinov. All rights reserved.
//

import UIKit

class UserProfilePhotoCell: UICollectionViewCell {
    var post: Post? {
        didSet {
            guard let imageUrl = post?.imageUrl else { return }
            
            guard let url = URL(string: imageUrl) else { return }
            
            URLSession.shared.dataTask(with: url) { (data, response, err) in
                //check for the error, then construct the image using data
                if let err = err {
                    print("Failed to fetch profile image:", err)
                    return
                }
                
                //perhaps check for response status of 200 (HTTP OK)
                
                guard let imageData = data else { return }
                
                let photoImage = UIImage(data: imageData)
                
                //need to get back onto the main UI thread
                DispatchQueue.main.async {
                    self.profileImageView.image = photoImage
                }
                
                }.resume()
        }
    }
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .white
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
