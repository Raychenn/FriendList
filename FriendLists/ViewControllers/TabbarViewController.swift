//
//  TabbarViewController.swift
//  FriendLists
//
//  Created by Boray Chen on 2025/2/22.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        // Configure tab bar appearance
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
        
        // Create view controllers
        let walletVC = UIViewController()
        let friendsVC = UINavigationController(rootViewController: MainContainerViewController())
        let kokoVC = UIViewController()
        let accountingVC = UIViewController()
        let settingsVC = UIViewController()
        
        // Configure tab bar items
        walletVC.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(resource: .icTabbarProductsOff),
            selectedImage: UIImage(resource: .icTabbarProductsOff)
        )
        
        friendsVC.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(resource: .icTabbarFriendsOn),
            selectedImage: UIImage(resource: .icTabbarFriendsOn)
        )
        
        kokoVC.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(resource: .icTabbarHomeOff).withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(resource: .icTabbarHomeOff).withRenderingMode(.alwaysOriginal)
        )
                
        accountingVC.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(resource: .icTabbarManageOff),
            selectedImage: UIImage(resource: .icTabbarManageOff)
        )
        
        settingsVC.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(resource: .icTabbarSettingOff),
            selectedImage: UIImage(resource: .icTabbarSettingOff)
        )
        
        // Set tab bar colors
        tabBar.tintColor = UIColor(red: 236/255, green: 0, blue: 140/255, alpha: 1) // Pink color
        tabBar.unselectedItemTintColor = .gray
        
        // Set view controllers
        setViewControllers([walletVC, friendsVC, kokoVC, accountingVC, settingsVC], animated: false)
        
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -1)
        tabBar.layer.shadowOpacity = 0.1
        selectedIndex = 1
    }
}
