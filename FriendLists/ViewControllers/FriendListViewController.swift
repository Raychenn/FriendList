//
//  ViewController.swift
//  FriendLists
//
//  Created by Boray Chen on 2025/2/22.
//

import UIKit

protocol FriendListViewControllerDelegate: AnyObject {
    func friendListViewControllerOnRefresh(_ controller: FriendListViewController)
}

class FriendListViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: FriendListViewControllerDelegate?
    
    var friendLists: [Friend] = []
    
    var filteredFriends: [Friend] = []
    
    private let cardStackView: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        return stackView
    }()
    
    private lazy var frinendTabButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("好友", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .medium)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return button
    }()
    
    private lazy var addFriendButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(resource: .icBtnAddFriends).withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.tintColor = .systemGray
        return button
    }()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "想轉一筆給誰呢？"
        searchBar.searchBarStyle = .minimal
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        return searchBar
    }()
    
    let refreshControl = UIRefreshControl()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - Helpers

extension FriendListViewController {
    private func setupUI() {
        view.addSubview(searchBar)
        searchBar.anchor(top: view.topAnchor,
                         left: view.leadingAnchor,
                         paddingTop: 15,
                         paddingLeft: 30)
        
        view.addSubview(addFriendButton)
        addFriendButton.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor).isActive = true
        addFriendButton.leadingAnchor.constraint(equalTo: searchBar.trailingAnchor, constant: 15).isActive = true
        addFriendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        
        setupTableView()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.register(FriendCell.self, forCellReuseIdentifier: String(describing: FriendCell.self))
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
        
    @objc private func refreshData() {
        delegate?.friendListViewControllerOnRefresh(self)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension FriendListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchBar.text?.isEmpty ?? true ? friendLists.count : filteredFriends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FriendCell.self), for: indexPath) as? FriendCell else {
            return UITableViewCell()
        }
        let friend = searchBar.text?.isEmpty ?? true ? friendLists[indexPath.row] : filteredFriends[indexPath.row]
        cell.configure(with: friend)
        return cell
    }
}

// MARK: - UISearchResultsUpdating
extension FriendListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchText.isEmpty == false else {
            searchBar.text = nil
            tableView.reloadData()
            return
        }
        filterFriends(for: searchText)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        // move to view model
        tableView.reloadData()
    }
    
    private func filterFriends(for searchText: String) {
        filteredFriends = friendLists.filter { friend in
            return friend.name.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
}


