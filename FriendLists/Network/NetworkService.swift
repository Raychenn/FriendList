//
//  NetworkService.swift
//  FriendLists
//
//  Created by Boray Chen on 2025/2/22.
//
import Foundation

protocol NetworkServiceProtocol {
    func fetchCombinedFriendLists(completion: @escaping (Result<[Friend], APIError>) -> Void)
    func fetchFrindListsWithInvitation(completion: @escaping (Result<[Friend], APIError>) -> Void)
    func fetchUserInfo(completion: @escaping (Result<User, APIError>) -> Void)
}

final class NetworkService: HTTPClient, NetworkServiceProtocol {
    static let shared = NetworkService()
    private init() {}
    
    func fetchUserInfo(completion: @escaping (Result<User, APIError>) -> Void) {
        guard let url = Endpoint.userInfo().url else {
            completion(.failure(.requestFailed(description: "invalid URL")))
            return
        }
        
        fetchData(as: UserResponse.self, endPointURL: url) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    guard let user = response.users.first else {
                        completion(.failure(APIError.invalidData))
                        return
                    }
                    completion(.success(user))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func fetchFrindListsWithInvitation(completion: @escaping (Result<[Friend], APIError>) -> Void) {
        guard let url = Endpoint.friendListWithInvitations().url else {
            completion(.failure(.requestFailed(description: "invalid URL")))
            return
        }
        
        fetchData(as: FriendResponse.self, endPointURL: url) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    completion(.success(response.friends))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func fetchCombinedFriendLists(completion: @escaping (Result<[Friend], APIError>) -> Void) {
        let group = DispatchGroup()
        
        var firstListResult: Result<[Friend], APIError>?
        var secondListResult: Result<[Friend], APIError>?
        
        // Fetch first list
        group.enter()
        fetchFriendListOne { result in
            firstListResult = result
            group.leave()
        }
        
        // Fetch second list
        group.enter()
        fetchFriendListTwo { result in
            secondListResult = result
            group.leave()
        }
        
        // Handle completion
        group.notify(queue: .main) {
            // Unwrap and validate results
            guard let firstResult = firstListResult,
                  let secondResult = secondListResult else {
                completion(.failure(.requestFailed(description: "Invalid response")))
                return
            }
            
            // Process and merge results
            switch (firstResult, secondResult) {
            case (.success(let firstList), .success(let secondList)):
                // Merge both lists
                let allFriends = firstList + secondList
                completion(.success(allFriends))
                
            case (.failure(let error), _):
                // First list failed
                completion(.failure(error))
                
            case (_, .failure(let error)):
                // Second list failed
                completion(.failure(error))
            }
        }
    }
    
    private func fetchFriendListOne(completion: @escaping (Result<[Friend], APIError>) -> Void) {
        guard let url = Endpoint.standardFriendList1().url else {
            completion(.failure(.requestFailed(description: "invalid URL")))
            return
        }
        
        fetchData(as: FriendResponse.self, endPointURL: url) { result in
            switch result {
            case .success(let response):
                completion(.success(response.friends))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func fetchFriendListTwo(completion: @escaping (Result<[Friend], APIError>) -> Void) {
        guard let url = Endpoint.standardFriendList2().url else {
            completion(.failure(.requestFailed(description: "invalid URL")))
            return
        }
        
        fetchData(as: FriendResponse.self, endPointURL: url) { result in
            switch result {
            case .success(let response):
                completion(.success(response.friends))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
