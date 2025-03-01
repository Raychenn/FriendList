//
//  UnderlineTabView.swift
//  FriendLists
//
//  Created by Boray Chen on 2025/3/1.
//

import UIKit

struct NotificationView {
    let view: UIButton
    var notificationCount: Int
}

class UnderlineTabView: UIView {
    
    let tabViews: [NotificationView]
    
    private let horizontalPadding: CGFloat
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1)
        return view
    }()
    
    private let selectedLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 236/255, green: 0/255, blue: 140/255, alpha: 1)
        view.layer.cornerRadius = 2.5
        view.layer.masksToBounds = true
        return view
    }()
    
    init(contents: [NotificationView], horizontalPadding: CGFloat = 36) {
        self.tabViews = contents
        self.horizontalPadding = horizontalPadding
        super.init(frame: .zero)
        
        for (index, content) in contents.enumerated() {
            addSubview(content.view)
            
            if index == 0 {
                content.view.anchor(top: topAnchor,
                            left: leadingAnchor,
                            paddingTop: 10,
                            paddingLeft: 32)
            }
            
            if index > 0 {
                let formerView = contents[index-1].view
                content.view.anchor(top: topAnchor,
                                        left: formerView.trailingAnchor,
                                        paddingTop: 10,
                                  paddingLeft: self.horizontalPadding)
            }
            
            let badgeView = generateBadgeView(with: content.notificationCount)
            addSubview(badgeView)
            badgeView.leadingAnchor.constraint(equalTo: content.view.trailingAnchor, constant: 2.5).isActive = true
            badgeView.centerYAnchor.constraint(equalTo: content.view.centerYAnchor, constant: -8).isActive = true
        }
        
        // can modify the separatorView animation by creating a constraint later if needed
        addSubview(separatorView)
        separatorView.anchor(top: contents[0].view.bottomAnchor,
                             left: leadingAnchor,
                             right: trailingAnchor,
                             paddingTop: 9)
        separatorView.setHeight(1)

        addSubview(selectedLineView)
        selectedLineView.setHeight(4)
        selectedLineView.anchor(left: contents[0].view.leadingAnchor,
                                bottom: separatorView.bottomAnchor,
                                right: contents[0].view.trailingAnchor,
                                paddingTop: 9)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    private func generateBadgeView(with count: Int = 0) -> UIView {
        let view = BadgeView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setBadgeCount(count)
        view.alpha = count == 0 ? 0 : 1
        return view
    }
}
