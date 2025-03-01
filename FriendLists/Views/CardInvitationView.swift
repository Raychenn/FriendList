//
//  CardView.swift
//  FriendLists
//
//  Created by Boray Chen on 2025/2/24.
//

import UIKit

class CardInvitationView: UIView {
    
    static let cardHeight: CGFloat = 70
    
    static let cardSpacing: CGFloat = 6
    
    static let peekHeight: CGFloat = 9
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(resource: .imgFriendsList).withRenderingMode(.alwaysOriginal))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 40 / 2
        imageView.setDimensions(height: 40, width: 40)
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.text = "邀請你成為好友 :)"
        return label
    }()
    
    private lazy var acceptButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(resource: .btnFriendsAgree).withRenderingMode(.alwaysOriginal), for: .normal)
        button.layer.cornerRadius = 30/2
        button.layer.masksToBounds = true
        return button
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(resource: .btnFriendsDelet).withRenderingMode(.alwaysOriginal), for: .normal)
        button.layer.cornerRadius = 30/2
        button.layer.masksToBounds = true
        return button
    }()
    
    init(friend: Friend) {
        super.init(frame: .zero)
        setupUI()
        configure(with: friend)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Override hit test to ensure buttons work properly
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        
        // If the hit view is a button, return it
        if view is UIButton {
            return view
        }
        
        // If the point is inside this view, return self to handle the tap
        return point.y < CardInvitationView.cardHeight ? self : nil
    }
    
    private func setupUI() {
        layer.cornerRadius = 10
        layer.masksToBounds = true
        backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1.0)
        applyShadow()
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor,
                                left: leadingAnchor,
                                bottom: bottomAnchor,
                                paddingTop: 15,
                                paddingLeft: 15,
                                paddingBottom: 15)
        
        addSubview(nameLabel)
        nameLabel.anchor(top: profileImageView.topAnchor,
                         left: profileImageView.trailingAnchor,
                         paddingLeft: 15)
        
        
        addSubview(descriptionLabel)
        descriptionLabel.anchor(top: nameLabel.bottomAnchor,
                                left: profileImageView.trailingAnchor,
                                paddingTop: 2,
                                paddingLeft: 15)

        addSubview(deleteButton)
        deleteButton.anchor(top: topAnchor,
                            bottom: bottomAnchor,
                            right: trailingAnchor,
                            paddingTop: 20,
                            paddingBottom: 20,
                            paddingRight: 15)
        
        addSubview(acceptButton)
        acceptButton.anchor(top: topAnchor,
                            bottom: bottomAnchor,
                            right: deleteButton.leadingAnchor,
                            paddingTop: 20,
                            paddingBottom: 20,
                            paddingRight: 15)
    }
    
    private func configure(with friend: Friend) {
        nameLabel.text = friend.name
        descriptionLabel.text = "邀請你成為好友：）"
    }

}

