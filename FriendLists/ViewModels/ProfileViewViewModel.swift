//
//  ProfileViewViewModel.swift
//  FriendLists
//
//  Created by Boray Chen on 2025/2/22.
//

import Foundation

protocol ProfileViewViewModelProtocol {
    var user: User? { get }
    var onProfileUpdated: ((User) -> Void)? { get set}
    func fetchUser()
}

class ProfileViewViewModel: ProfileViewViewModelProtocol {
    
    var onProfileUpdated: ((User) -> Void)?
    
    private(set) var user: User? {
        didSet {
            guard let user else {
                return
            }
            onProfileUpdated?(user)
        }
    }
    
    private let service: NetworkServiceProtocol
    
    init(service: NetworkServiceProtocol = NetworkService.shared) {
        self.service = service
    }
    
    func fetchUser() {
        service.fetchUserInfo { [weak self] result in
            guard let self else {
                return
            }
            switch result {
              case .success(let user):
                self.user = user
            case .failure(let error):
                // could handle possible error depending on Spec
                print(error)
            }
        }
    }
    
}
