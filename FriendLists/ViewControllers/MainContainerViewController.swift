//
//  MainContainerViewController.swift
//  FriendLists
//
//  Created by Boray Chen on 2025/2/22.
//

import UIKit

class MainContainerViewController: UIViewController {
    
    // MARK: - properties
    
    var viewModel: FriendListViewModelProtocol
        
    private var underlineTabViewTopAnchor: NSLayoutConstraint?
    
    private var isExpanded = false
    
    private var cardViews: [CardInvitationView] = []
    
    private lazy var contentViews = [
        NotificationView(view: UIButton.generateTabButton(with: "好友"), notificationCount: 2),
        NotificationView(view: UIButton.generateTabButton(with: "聊天"), notificationCount: 99)
    ]
    
    private lazy var underlineTabView = UnderlineTabView(contents: contentViews)
    
    private var loadingIndicator: UIActivityIndicatorView?
    
    private let cardsContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let profileView: ProfileView = {
        let view = ProfileView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var friendListViewController: FriendListViewController = {
        let vc = FriendListViewController()
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.delegate = self
        return vc
    }()
    
    init(viewModel: FriendListViewModelProtocol = FriendListViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showInitialAlert()
        setupBinding()
    }
}

// MARK: - General helper functions

extension MainContainerViewController {
    private func setupNavigationBar() {
        let atmButton = UIBarButtonItem(image: UIImage(resource: .icNavPinkWithdraw).withRenderingMode(.alwaysOriginal),
                                        style: .plain,
                                        target: self,
                                        action: #selector(handleATMBtn))
        
        let transferButton = UIBarButtonItem(image: UIImage(resource: .icNavPinkTransfer).withRenderingMode(.alwaysOriginal),
                                        style: .plain,
                                        target: self,
                                        action: #selector(handleTransferBtn))
        
        let scanButton = UIBarButtonItem(image: UIImage(resource: .icNavPinkScan).withRenderingMode(.alwaysOriginal),
                                        style: .plain,
                                        target: self,
                                        action: #selector(handleScanBtn))
        
        self.navigationItem.leftBarButtonItems = [atmButton, transferButton]
        self.navigationItem.rightBarButtonItems = [scanButton]
    }
    
    private func setupUI(with option: HttpRequestOption) {
        view.backgroundColor = UIColor(red: 252, green: 252, blue: 252, alpha: 1.0)
        
        view.addSubview(profileView)
        profileView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leadingAnchor, right: view.trailingAnchor, paddingTop: 27, height: 55)
        
        switch option {
        case .noFriends:
            setupUnderlineTabUI(with: option)
            setupEmptyStateUI()
        case .onlyFriends:
            setupUnderlineTabUI(with: option)
            setupChildViewController()
        case .friendsWithInvitation:
            setupCardsView()
            setupUnderlineTabUI(with: option)
            setupChildViewController()
        }
    }
    
    private func setupEmptyStateUI() {
        let emptyStateView = EmptyStateView()
        view.addSubview(emptyStateView)
        emptyStateView.anchor(top: underlineTabView.bottomAnchor,
                              left: view.leadingAnchor,
                              bottom: view.bottomAnchor,
                              right: view.trailingAnchor)
    }
    
    private func setupCardsView() {
        view.addSubview(cardsContainerView)
        cardsContainerView.anchor(top: profileView.bottomAnchor,
                                  left: view.leadingAnchor,
                                  right: view.trailingAnchor,
                                  paddingTop: 25,
                                  paddingLeft: 30,
                                  paddingRight: 30,
                                  height: CardInvitationView.cardHeight + CardInvitationView.peekHeight)
    }
    
    private func setupUnderlineTabUI(with option: HttpRequestOption) {
        view.addSubview(underlineTabView)

        if option == .friendsWithInvitation {
            underlineTabViewTopAnchor = underlineTabView.topAnchor.constraint(equalTo: cardsContainerView.bottomAnchor,
                                                                              constant: 15 + (BadgeView.height / 2))
        } else {
            underlineTabViewTopAnchor = underlineTabView.topAnchor.constraint(equalTo: profileView.bottomAnchor,
                                                                              constant: 23)
        }
        underlineTabView.anchor(left: view.leadingAnchor,
                                right: view.trailingAnchor,
                                height: 50)
        
        underlineTabViewTopAnchor?.isActive = true
    }
    
    private func setupChildViewController() {
        addChild(friendListViewController)
        view.addSubview(friendListViewController.view)
        
        NSLayoutConstraint.activate([
            friendListViewController.view.topAnchor.constraint(equalTo: underlineTabView.bottomAnchor),
            friendListViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            friendListViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            friendListViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        friendListViewController.didMove(toParent: self)
    }
    
    private func compositeCardViews(with friends: [Friend]) {
        cardsContainerView.subviews.forEach { $0.removeFromSuperview() }
        cardViews.removeAll()
        
        for (index, friend) in friends.enumerated() {
            let cardView = CardInvitationView(friend: friend)
            cardView.translatesAutoresizingMaskIntoConstraints = false
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            cardView.addGestureRecognizer(tap)
            cardView.isUserInteractionEnabled = true
            cardsContainerView.insertSubview(cardView, at: 0)
            cardViews.append(cardView)
            
            NSLayoutConstraint.activate([
                cardView.leadingAnchor.constraint(equalTo: cardsContainerView.leadingAnchor),
                cardView.trailingAnchor.constraint(equalTo: cardsContainerView.trailingAnchor),
                cardView.heightAnchor.constraint(equalToConstant: CardInvitationView.cardHeight)
            ])
            
            // Position cards
            if index == 0 {
                cardView.topAnchor.constraint(equalTo: cardsContainerView.topAnchor).isActive = true
            } else {
                // Initially position subsequent cards with just a peek showing
                cardView.topAnchor.constraint(equalTo: cardViews[0].topAnchor,
                                              constant: CardInvitationView.peekHeight).isActive = true
            }
        }
    }
    
    private func startSetupFlow(with option: HttpRequestOption) {
        setupNavigationBar()
        setupUI(with: option)
        fetchData()
    }
    
    private func showInitialAlert(completion: (() -> Void)? = nil) {
        let noFriendsAction = UIAlertAction(title: "無好友", style: .default) { [weak self] _ in
            self?.viewModel.selectedRequestOption = .noFriends
            completion?()
        }
        let onlyFriendsAction = UIAlertAction(title: "好友列表", style: .default) { [weak self] _ in
            self?.viewModel.selectedRequestOption = .onlyFriends
            completion?()
        }
        let friendsWithInvitationAction = UIAlertAction(title: "好友列表含邀請", style: .default) { [weak self] _ in
            self?.viewModel.selectedRequestOption = .friendsWithInvitation
            completion?()
        }
        
        let alertController = UIAlertController(title: "請選擇以下行為", message: nil, preferredStyle: .alert)
        
        [noFriendsAction, onlyFriendsAction, friendsWithInvitationAction].forEach({ alertController.addAction($0) })
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func showLoadingIndicator() {
        DispatchQueue.main.async {
            self.loadingIndicator = UIActivityIndicatorView(style: .large)
            guard let loadingIndicator = self.loadingIndicator else { return }
            
            loadingIndicator.center = self.view.center
            loadingIndicator.color = .gray
            loadingIndicator.hidesWhenStopped = true
            
            self.view.addSubview(loadingIndicator)
            loadingIndicator.startAnimating()
        }
    }

    private func hideLoadingIndicator() {
        DispatchQueue.main.async {
            self.loadingIndicator?.stopAnimating()
            self.loadingIndicator?.removeFromSuperview()
            self.loadingIndicator = nil
        }
    }
}

// MARK: - Data processing & Binding

extension MainContainerViewController {
    private func setupBinding() {
        viewModel.onFriendsWithInvitationUpdated = { [weak self] friends in
            guard let self else {
                return
            }
            
            self.compositeCardViews(with: friends)
        }
        
        viewModel.onFriendsUpdated = { [weak self] friends in
            guard let self else {
                return
            }
            self.friendListViewController.refreshControl.endRefreshing()
            self.friendListViewController.friendLists = friends
            self.friendListViewController.tableView.reloadData()
        }
        
        viewModel.onSelectedRequestOptionStateChanged = { [weak self] option in
            guard let self else {
                return
            }
            self.startSetupFlow(with: option)
        }
        
        viewModel.onAsynchronousTaskLoading = { [weak self] in
            guard let self else {
                return
            }
            self.showLoadingIndicator()
        }
        
        viewModel.onAsynchronousTaskFinished = { [weak self] in
            guard let self else {
                return
            }
            self.hideLoadingIndicator()
        }
        
        viewModel.onAsynchronousTaskErrorReceived = { error in
            // handle possible error depending on Spec
            print("API error: \(error)")
        }
        
        profileView.viewModel.onProfileUpdated = { [weak self] user in
            guard let user = self?.profileView.viewModel.user else { return }
            self?.profileView.configure(with: user)
        }
    }
    
    private func fetchData() {
        DispatchQueue.global(qos: .userInitiated).async {
            let selectedOption = self.viewModel.selectedRequestOption ?? .noFriends
            self.viewModel.fetchFriendsList(from: selectedOption)
            self.profileView.viewModel.fetchUser()
        }
    }
}

// MARK: - Stack CardViews Animation

extension MainContainerViewController {
    @objc func handleTap() {
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.5) {
            self.isExpanded.toggle()
            self.animateCardViews()
        }
    }
    
    // Helper method to animate card views
    private func animateCardViews() {
        for (index, cardView) in cardViews.enumerated() {
            let yOffset = calculateYOffset(for: index)
            
            if index > 0 {
                // Apply the calculated translation for all card views except the first one
                cardView.transform = CGAffineTransform(translationX: 0, y: yOffset)
            }
            
            if index == cardViews.count - 1 {
                updateFriendListTopAnchor(yOffset: yOffset)
            }
        }
    }
    
    private func calculateYOffset(for index: Int) -> CGFloat {
        return isExpanded ?
        CGFloat(index) * (CardInvitationView.cardHeight + CardInvitationView.cardSpacing) :
        (CardInvitationView.peekHeight - CardInvitationView.cardSpacing)
    }
    
    private func updateFriendListTopAnchor(yOffset: CGFloat) {
        underlineTabViewTopAnchor?.isActive = false
        underlineTabViewTopAnchor?.constant = yOffset
        underlineTabViewTopAnchor?.isActive = true
    }
}

// MARK: - NavigationBar Actions

extension MainContainerViewController {
    @objc func handleATMBtn() {}
    
    @objc func handleTransferBtn() {}
    
    @objc func handleScanBtn() {}
}

// MARK: - FriendListViewControllerDelegate
 
extension MainContainerViewController: FriendListViewControllerDelegate {
    
    func friendListViewControllerOnRefresh(_ controller: FriendListViewController) {
        controller.refreshControl.beginRefreshing()
        viewModel.fetchFriendsList(from: viewModel.selectedRequestOption ?? .noFriends)
    }
    
}
