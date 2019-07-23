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
    
    init(dictionary: [String: Any]) {
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"]  as? String ?? ""
    }
}
