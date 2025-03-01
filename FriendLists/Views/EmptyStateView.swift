//
//  EmptyStateView.swift
//  FriendLists
//
//  Created by Boray Chen on 2025/3/1.
//

import UIKit

class EmptyStateView: UIView {
    
    private let emptyStateImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(resource: .imgFriendsEmpty).withRenderingMode(.alwaysOriginal))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21, weight: .medium)
        label.textColor = UIColor(red: 71/255, green: 71/255, blue: 71/255, alpha: 1)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "就從加好友開始吧：）"
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1)
        label.textAlignment = .center
        label.numberOfLines = 0 
        label.text = "與好友們一起用 KOKO 聊起來！\n 還能互相收付款、發紅包喔：）"
        return label
    }()
    
    private lazy var addFriendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(UIColor(red: 255/255, green: 122/255, blue: 87/255, alpha: 1), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("加好友", for: .normal)
        button.layer.cornerRadius = 40 / 2
        button.layer.masksToBounds = true
        button.setDimensions(height: 40, width: 192)
        
        let iconImageView = UIImageView(image: UIImage(resource: .icAddFriendWhite).withRenderingMode(.alwaysOriginal))
        iconImageView.contentMode = .scaleAspectFit
        button.addSubview(iconImageView)
        let padding: CGFloat = 8
        iconImageView.anchor(top: button.topAnchor,
                             bottom: button.bottomAnchor,
                             right: button.trailingAnchor,
                             paddingTop: padding,
                             paddingBottom: padding,
                             paddingRight: padding)
        return button
    }()
    
    private lazy var hintLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1)
        label.textAlignment = .center
        
        // handle attributed string
        let firstWord = "幫助好友更快找到你？"
        let secondWord = "設定 KOKO ID"
        // Create a mutable attributed string
        let attributedString = NSMutableAttributedString(string: firstWord + " " + secondWord)

        let firstWordRange = (attributedString.string as NSString).range(of: firstWord)
        let linkRange = (attributedString.string as NSString).range(of: secondWord)
        attributedString.addAttribute(.foregroundColor, value: UIColor.lightGray, range: firstWordRange)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: linkRange)
        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 236/255, green: 0/255, blue: 140/255, alpha: 1), range: linkRange)
        label.attributedText = attributedString
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let startColor = UIColor(red: 86/255, green: 179/255, blue: 11/255, alpha: 1).cgColor
        let endColor = UIColor(red: 166/255, green: 204/255, blue: 66/255, alpha: 1).cgColor
        addFriendButton.applyHorizontalGradient(colors: [startColor, endColor])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(emptyStateImageView)
        emptyStateImageView.centerX(inView: self)
        emptyStateImageView.anchor(top: topAnchor, paddingTop: 30)
        
        addSubview(titleLabel)
        titleLabel.centerX(inView: self)
        titleLabel.anchor(top: emptyStateImageView.bottomAnchor, paddingTop: 41)
        
        addSubview(subtitleLabel)
        subtitleLabel.centerX(inView: self)
        subtitleLabel.anchor(top: titleLabel.bottomAnchor, paddingTop: 8)
        
        addSubview(addFriendButton)
        addFriendButton.centerX(inView: self)
        addFriendButton.anchor(top: subtitleLabel.bottomAnchor, paddingTop: 25)
        
        addSubview(hintLabel)
        hintLabel.centerX(inView: self)
        hintLabel.anchor(top: addFriendButton.bottomAnchor, paddingTop: 37)
    }
}
