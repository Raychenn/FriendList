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
    
    private func fetchFriends() {
        onAsynchronousTaskLoading?()
        service.fetchCombinedFriendLists { result in
            self.onAsynchronousTaskFinished?()
            switch result {
            case .success(let friends):
                self.friends = friends.removeDuplicateFriends()
            case .failure(let error):
                self.onAsynchronousTaskErrorReceived?(error)
            }
        }
    }
    
    private func fetchFriendsWithInvitation() {
        onAsynchronousTaskLoading?()
        service.fetchFrindListsWithInvitation { result in
            self.onAsynchronousTaskFinished?()
            switch result {
            case .success(let friends):
                self.friendsWithInvitation = friends.invitingFriends()
                self.friends = friends.removeDuplicateFriends().invitedFriends()
            case .failure(let error):
                self.onAsynchronousTaskErrorReceived?(error)
            }
        }
    }
}
