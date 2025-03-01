//
//  EndPoint.swift
//  FriendLists
//
//  Created by Boray Chen on 2025/2/22.
//

import Foundation

struct Endpoint {
    let path: String
    let queryItems: [URLQueryItem]?
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "dimanyen.github.io"
        components.path = path
        components.queryItems = queryItems
        return components.url
    }
    
    // Enum to represent all API endpoints
    enum APIEndpoint {
        case userInfo
        case friendList(FriendListType)
        
        // Nested enum for different friend list types
        enum FriendListType {
            case standard1
            case standard2
            case withInvitations
            case empty
            
            var filename: String {
                switch self {
                case .standard1: return "friend1.json"
                case .standard2: return "friend2.json"
                case .withInvitations: return "friend3.json"
                case .empty: return "friend4.json"
                }
            }
        }
        
        var path: String {
            switch self {
            case .userInfo:
                return "/man.json"
            case .friendList(let type):
                return "/\(type.filename)"
            }
        }
    }
    
    // Factory methods for creating endpoints
    static func endpoint(for api: APIEndpoint) -> Endpoint {
        Endpoint(path: api.path, queryItems: nil)
    }
}

// MARK: - Convenience Extensions
extension Endpoint {
    // User endpoints
    static func userInfo() -> Endpoint {
        endpoint(for: .userInfo)
    }
    
    // Friend list endpoints
    static func standardFriendList1() -> Endpoint {
        endpoint(for: .friendList(.standard1))
    }
    
    static func standardFriendList2() -> Endpoint {
        endpoint(for: .friendList(.standard2))
    }
    
    static func friendListWithInvitations() -> Endpoint {
        endpoint(for: .friendList(.withInvitations))
    }
    
    static func emptyFriendList() -> Endpoint {
        endpoint(for: .friendList(.empty))
    }
}
