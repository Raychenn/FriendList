//
//  FriendListViewModelProtocol.swift
//  FriendLists
//
//  Created by Boray Chen on 2025/2/22.
//

import Foundation

protocol FriendListViewModelProtocol {
    var selectedRequestOption: HttpRequestOption? { get set }
    var friendsWithInvitation: [Friend] { get }
    var friends: [Friend] { get }
    var onFriendsUpdated: (([Friend]) -> Void)? { get set }
    var onFriendsWithInvitationUpdated: (([Friend]) -> Void)? { get set }
    var onSelectedRequestOptionStateChanged: ((HttpRequestOption) -> Void)? { get set }
    var onAsynchronousTaskLoading: (() -> Void)? { get set }
    var onAsynchronousTaskFinished: (() -> Void)? { get set }
    var onAsynchronousTaskErrorReceived: ((APIError) -> Void)? { get set }
    func fetchFriendsList(from option: HttpRequestOption)
}

enum HttpRequestOption {
    case noFriends
    case onlyFriends
    case friendsWithInvitation
}

final class FriendListViewModel: FriendListViewModelProtocol {
    
    private let service: NetworkServiceProtocol
    
    var onSelectedRequestOptionStateChanged: ((HttpRequestOption) -> Void)?
    
    var selectedRequestOption: HttpRequestOption? {
        didSet {
            onSelectedRequestOptionStateChanged?(selectedRequestOption ?? .noFriends)
        }
    }
    
    private(set) var friendsWithInvitation: [Friend] = [] {
        didSet {
            onFriendsWithInvitationUpdated?(friendsWithInvitation)
        }
    }
    
    private(set) var friends: [Friend] = [] {
        didSet {
            onFriendsUpdated?(friends)
        }
    }
    
    var onFriendsUpdated: (([Friend]) -> Void)?
    
    var onFriendsWithInvitationUpdated: (([Friend]) -> Void)?
    
    var onAsynchronousTaskLoading: (() -> Void)?
    
    var onAsynchronousTaskFinished: (() -> Void)?
    
    var onAsynchronousTaskErrorReceived: ((APIError) -> Void)?
    
    init(service: NetworkServiceProtocol = NetworkService.shared) {
        self.service = service
    }

    func fetchFriendsList(from option: HttpRequestOption) {
        switch option {
            case .noFriends:
            break
        case .onlyFriends:
            fetchFriends()
        case .friendsWithInvitation:
            fetchFriendsWithInvitation()
        }
    }
    
    func fetchFriends() {
        onAsynchronousTaskLoading?()
        service.fetchCombinedFriendLists { result in
            self.onAsynchronousTaskFinished?()
            switch result {
            case .success(let friends):
                self.friends = self.removeDuplicateFriends(friends)
            case .failure(let error):
                self.onAsynchronousTaskErrorReceived?(error)
            }
        }
    }
    
    func fetchFriendsWithInvitation() {
        onAsynchronousTaskLoading?()
        service.fetchFrindListsWithInvitation { result in
            self.onAsynchronousTaskFinished?()
            switch result {
            case .success(let friends):
                self.friendsWithInvitation = self.invitingFriends(friends)
                self.friends = self.removeDuplicateFriends(friends)
            case .failure(let error):
                self.onAsynchronousTaskErrorReceived?(error)
            }
        }
    }
    
    private func removeDuplicateFriends(_ friends: [Friend]) -> [Friend] {
        var resultDict: [String: Friend] = [:]
        
        for friend in friends {
            if let existingFriend = resultDict[friend.id] {
                // Compare the updateDate of the existing friend and the current friend
                if let existingDate = existingFriend.formattedUpdateDate,
                   let newDate = friend.formattedUpdateDate,
                   newDate > existingDate {
                    // If the current friend has a later date, update the dictionary with the new friend
                    resultDict[friend.id] = friend
                }
            } else {
                resultDict[friend.id] = friend
            }
        }
        
        return Array(resultDict.values)
    }
    
    private func invitingFriends(_ friends: [Friend]) -> [Friend] {
        return friends.filter( { $0.status == .sentInvitation } )
    }
}
