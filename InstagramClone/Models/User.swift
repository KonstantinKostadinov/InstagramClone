//
//  User.swift
//  InstagramClone
//
//  Created by Konstantin Kostadinov on 23.07.19.
//  Copyright © 2019 Konstantin Kostadinov. All rights reserved.
//

import Foundation
struct User {
    let username: String
    let profileImageUrl: String
    let uid: String
    init(uid: String,dictionary: [String: Any]) {
        self.uid = uid
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"]  as? String ?? ""
    }
}
