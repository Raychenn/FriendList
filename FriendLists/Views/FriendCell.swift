//
//  FriendCell.swift
//  FriendLists
//
//  Created by Boray Chen on 2025/2/22.
//

import UIKit

final class FriendCell: UITableViewCell {
    
    private let avatarImageView: UIImageView = {
        let avatarImageView = UIImageView(image: UIImage(resource: .imgFriendsList).withRenderingMode(.alwaysOriginal))
        avatarImageView.setDimensions(height: 40, width: 40)
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.layer.cornerRadius = 40 / 2
        avatarImageView.clipsToBounds = true
        return avatarImageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private lazy var transferButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("轉帳", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .medium)
        button.titleEdgeInsets = UIEdgeInsets(top: 2, left: 10, bottom: 2, right: 10)
        button.setTitleColor(UIColor(red: 236/255, green: 0/255, blue: 140/255, alpha: 1), for: .normal)
        button.tintColor = UIColor(red: 236/255, green: 0/255, blue: 140/255, alpha: 1)
        button.layer.borderColor = UIColor(red: 236/255, green: 0/255, blue: 140/255, alpha: 1).cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 4
        
        return button
    }()
    
    private lazy var inviteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("邀請中", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .medium)
        button.titleEdgeInsets = UIEdgeInsets(top: 2, left: 10, bottom: 2, right: 10)
        button.setTitleColor(UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1), for: .normal)
        button.tintColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1)
        button.layer.borderColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1).cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 4
        return button
    }()
    
    private lazy var optionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(resource: .icFriendsMore).withRenderingMode(.alwaysOriginal), for: .normal)
        button.alpha = 0
        return button
    }()
    
    private let starImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(resource: .icFriendsStar).withRenderingMode(.alwaysOriginal))
        imageView.setDimensions(height: 14, width: 14)
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(starImageView)
        starImageView.anchor(top: contentView.topAnchor,
                             left: contentView.leadingAnchor,
                             bottom: contentView.bottomAnchor,
                             paddingTop: 23,
                             paddingLeft: 30,
                             paddingBottom: 23)
        
        // Setup avatar
        contentView.addSubview(avatarImageView)
        avatarImageView.centerY(inView: starImageView,
                               leftAnchor: starImageView.trailingAnchor,
                               paddingLeft: 6)
        
        // Setup name label
        contentView.addSubview(nameLabel)
        nameLabel.centerY(inView: avatarImageView,
                          leftAnchor: avatarImageView.trailingAnchor,
                          paddingLeft: 15)
        
        contentView.addSubview(inviteButton)
        inviteButton.anchor(top: contentView.topAnchor,
                            bottom: contentView.bottomAnchor,
                            right: contentView.trailingAnchor,
                            paddingTop: 18,
                            paddingBottom: 18,
                            paddingRight: 20)
        inviteButton.setDimensions(height: 24, width: 60)
        
        contentView.addSubview(optionButton)
        optionButton.anchor(top: contentView.topAnchor,
                            bottom: contentView.bottomAnchor,
                            right: contentView.trailingAnchor,
                            paddingTop: 18,
                            paddingBottom: 18,
                            paddingRight: 20)
        optionButton.setDimensions(height: 24, width: 60)
        
        // Setup transfer button
        contentView.addSubview(transferButton)
        transferButton.anchor(top: contentView.topAnchor,
                              bottom: contentView.bottomAnchor,
                              right: inviteButton.leadingAnchor,
                              paddingTop: 18,
                              paddingBottom: 18,
                              paddingRight: 10)
        transferButton.setDimensions(height: 24, width: 47)
    }
    
    func configure(with friend: Friend) {
        nameLabel.text = friend.name
        starImageView.alpha = friend.isFavorite ? 1 : 0
        optionButton.alpha = friend.status == .invited ? 1 : 0
        inviteButton.alpha = friend.status == .inviting ? 1 : 0
    }
}
