//
//  Comment.swift
//  InstagramClone
//
//  Created by Konstantin Kostadinov on 30.07.19.
//  Copyright © 2019 Konstantin Kostadinov. All rights reserved.
//

import Foundation

struct Comment {
    var user: User
    let text: String
    let uid: String
    
    init(user: User,dictionary: [String:Any]) {
        self.user = user
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}
