//
//  Post.swift
//  InstagramClone
//
//  Created by Konstantin Kostadinov on 20.07.19.
//  Copyright © 2019 Konstantin Kostadinov. All rights reserved.
//

import Foundation
struct Post {
    let imageUrl: String
    init(dictionary: [String:Any]) {
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
    }
}
