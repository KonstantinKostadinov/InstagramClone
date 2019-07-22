//
//  CustomImageView.swift
//  InstagramClone
//
//  Created by Konstantin Kostadinov on 20.07.19.
//  Copyright © 2019 Konstantin Kostadinov. All rights reserved.
//

import UIKit
var imageCache = [String:UIImage]()

class CustomImageView: UIImageView{
    
    var lastURLUsedToLoadImage: String?
    func loadImage(urlString: String){
        
        lastURLUsedToLoadImage = urlString
        
        if let cachedImage = imageCache[urlString]{
            self.image = cachedImage
            return
        }
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            //check for the error, then construct the image using data
            if let err = err {
                print("Failed to fetch profile image:", err)
                return
            }
            if url.absoluteString != self.lastURLUsedToLoadImage {
                return
            }
            
            guard let imageData = data else { return }
            
            let photoImage = UIImage(data: imageData)
            imageCache[url.absoluteString] = photoImage
            //need to get back onto the main UI thread
            DispatchQueue.main.async {
                self.image = photoImage
            }
            
            }.resume()
    }
}

