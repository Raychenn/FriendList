//
//  User.swift
//  FriendLists
//
//  Created by Boray Chen on 2025/2/22.
//

import Foundation

struct UserResponse: Codable {
    let users: [User]
    
    enum CodingKeys: String, CodingKey {
        case users = "response"
    }
}

struct User: Codable {
    var id: String
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case id = "kokoid"
        case name
    }
}
