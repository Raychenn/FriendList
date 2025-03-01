//
//  UIButton+extension.swift
//  FriendLists
//
//  Created by Boray Chen on 2025/3/1.
//

import UIKit

extension UIButton {
    static func generateTabButton(with title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .medium)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return button
    }
}
