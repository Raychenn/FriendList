//
//  MockNetworkService.swift
//  FriendListsTests
//
//  Created by Boray Chen on 2025/3/2.
//

import Foundation
@testable import FriendLists

class MockNetworkService: NetworkServiceProtocol {

    var mockFriendResult: Result<[Friend], APIError>?
    
    func fetchCombinedFriendLists(completion: @escaping (Result<[Friend], APIError>) -> Void) {
        if let result = mockFriendResult {
            completion(result)
        }
    }
    
    func fetchFrindListsWithInvitation(completion: @escaping (Result<[Friend], APIError>) -> Void) {
        if let result = mockFriendResult {
            completion(result)
        }
    }
    
    func fetchUserInfo(completion: @escaping (Result<FriendLists.User, FriendLists.APIError>) -> Void) {
        
    }
}
