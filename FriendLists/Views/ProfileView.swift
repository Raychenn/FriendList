//
//  ProfileView.swift
//  FriendLists
//
//  Created by Boray Chen on 2025/2/22.
//

import UIKit

class ProfileView: UIView {
    
    var viewModel: ProfileViewViewModelProtocol
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(resource: .imgFriendsList).withRenderingMode(.alwaysOriginal)
        imageView.setDimensions(height: 52, width: 52)
        imageView.layer.cornerRadius = 52 / 2
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private let userIdLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.text = "KOKO ID：olylinhuang"
        return label
    }()
    
    init(viewModel: ProfileViewViewModelProtocol = ProfileViewViewModel()) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupUI() {
        addSubview(avatarImageView)
        avatarImageView.snapshotView(afterScreenUpdates: false)
        avatarImageView.anchor(top: topAnchor, right: trailingAnchor, paddingRight: 52)
        
        addSubview(usernameLabel)
        usernameLabel.anchor(top: topAnchor, left: leadingAnchor, paddingLeft: 30)
        
        addSubview(userIdLabel)
        userIdLabel.anchor(top: usernameLabel.bottomAnchor, left: leadingAnchor, paddingTop: 8, paddingLeft: 30)
    }
    
    func configure(with user: User) {
        usernameLabel.text = user.name
        userIdLabel.text = "KOKO ID：\(user.id) >"
    }
}
