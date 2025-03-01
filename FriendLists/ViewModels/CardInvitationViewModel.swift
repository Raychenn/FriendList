//
//  CardInvitationViewModel.swift
//  FriendLists
//
//  Created by Boray Chen on 2025/2/24.
//

import Foundation

protocol CardInvitationViewModelProtocol {
    var requestUsers: [User] { get }
    var onRequestsUpdated: (() -> Void)? { get set }
    func fetchRequests()
}

final class CardInvitationViewModel: CardInvitationViewModelProtocol {
    
    private let service: NetworkServiceProtocol
    
    private(set) var requestUsers: [User] = [] {
        didSet {
            onRequestsUpdated?()
        }
    }
    
    var onRequestsUpdated: (() -> Void)?
    
    init(service: NetworkServiceProtocol = NetworkService.shared) {
        self.service = service
    }

    func fetchRequests() {
        
    }
}
