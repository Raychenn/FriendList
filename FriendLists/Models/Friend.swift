//
//  Friend.swift
//  FriendLists
//
//  Created by Boray Chen on 2025/2/22.
//

import Foundation

struct FriendResponse: Codable {
    let friends: [Friend]
    
    enum CodingKeys: String, CodingKey {
        case friends = "response"
    }
}

struct Friend: Codable {
    let id: String
    let name: String
    let isTop: String
    let status: FriendStatus
    let updateDate: String
    
    enum CodingKeys: String, CodingKey {
        case id = "fid"
        case name, isTop, status, updateDate
    }
    
    enum FriendStatus: Int, Codable {
        case sentInvitation = 0
        case invited = 1
        case inviting = 2
        
        var description: String {
            switch self {
            case .sentInvitation:
                return "Sent Invitation"
            case .invited:
                return "Invited"
            case .inviting:
                return "Inviting"
            }
        }
    }
    
    var formattedUpdateDate: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd" // Match the format in the JSON
        return formatter.date(from: updateDate)
    }
    
    var isFavorite: Bool {
        return isTop == "1"
    }
}
