//
//  BadgeView.swift
//  FriendLists
//
//  Created by Boray Chen on 2025/3/1.
//

import UIKit

class BadgeView: UIView {
    static let height: CGFloat = 20
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = UIColor(red: 249/255, green: 178/255, blue: 200/255, alpha: 1)
        layer.cornerRadius = BadgeView.height / 2 
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            heightAnchor.constraint(equalToConstant: BadgeView.height)
        ])
    }
    
    func setBadgeCount(_ count: Int) {
        let text = count >= 99 ? "99+" : "\(count)"
        label.text = text
        
        let padding: CGFloat = 6
        let labelWidth = text.size(withAttributes: [
            .font: label.font as Any
        ]).width
        
        let minWidth: CGFloat = 20
        let width = max(minWidth, labelWidth + padding * 2)
        
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
}
