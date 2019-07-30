//
//  Post.swift
//  InstagramClone
//
//  Created by Konstantin Kostadinov on 20.07.19.
//  Copyright © 2019 Konstantin Kostadinov. All rights reserved.
//

import Foundation
struct Post {
    var id: String?
    let imageUrl: String
    let user: User
    let caption: String
    let creationDate: Date
    init(user: User,dictionary: [String:Any]) {
        self.user = user
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.caption = dictionary["caption"] as? String ?? ""
        
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
}
