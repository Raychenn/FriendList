//
//  FriendListsTests.swift
//  FriendListsTests
//
//  Created by Boray Chen on 2025/2/22.
//

import XCTest
@testable import FriendLists

class FriendListViewModelTests: XCTestCase {

    var viewModel: FriendListViewModel!
    var mockService: MockNetworkService!

    override func setUp() {
        super.setUp()
        mockService = MockNetworkService()
        viewModel = FriendListViewModel(service: mockService)
    }

    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }

    // Test for fetching friends success scenario
    func testFetchFriends_RepetingFriends_FilteringByLastestUpdateDate() {
        // Arrange: Create mock friends and set mock result to success
        let mockFriends = [Friend(id: "1", name: "Friend 1", isTop: "0", status: .invited, updateDate: "2022/12/01"),
                           Friend(id: "2", name: "Friend 2", isTop: "1", status: .inviting, updateDate: "2022/11/04"),
                           Friend(id: "2", name: "Friend 3", isTop: "1", status: .inviting, updateDate: "2022/11/01")]
        mockService.mockFriendResult = .success(mockFriends)
        
        var updatedFriends: [Friend] = []
        
        // Act: Attach completion handler for friends update and call fetchFriends
        viewModel.onFriendsUpdated = { friends in
            updatedFriends = friends
        }
        viewModel.fetchFriendsList(from: .onlyFriends)
        
        // Assert: The friends array should be updated with the mock friends
        XCTAssertEqual(updatedFriends.count, 2, "Friends array should contain 2 friends")
        XCTAssert(updatedFriends.contains(where: { $0.updateDate == "2022/11/04" }))
    }
    
    // Test for fetching friends failure scenario
    func testFetchFriends_Failure() {
        // Arrange: Set mock result to failure
        let mockError = APIError.requestFailed(description: "Invalid URL")
        mockService.mockFriendResult = .failure(mockError)
        
        var errorReceived: APIError?
        
        // Act: Attach completion handler for error and call fetchFriends
        viewModel.onAsynchronousTaskErrorReceived = { error in
            errorReceived = error
        }
        
        viewModel.fetchFriendsList(from: .onlyFriends)
        
        // Assert: The error should be passed through the ViewModel
        XCTAssertEqual(errorReceived, mockError, "Invalid URL")
    }

    // Test for fetching friends with invitation
    func testFetchFriendsWithInvitation_Success() {
        // Arrange: Create mock friends with different statuses
        let mockFriends = [Friend(id: "1", name: "Friend 1", isTop: "0", status: .sentInvitation, updateDate: "2022/12/01"),
                           Friend(id: "2", name: "Friend 2", isTop: "1", status: .invited, updateDate: "2022/11/01")]
        mockService.mockFriendResult = .success(mockFriends)
        
        var updatedFriendsWithInvitation: [Friend] = []
        var updatedFriends: [Friend] = []
        
        // Act: Attach completion handlers and call fetchFriendsWithInvitation
        viewModel.onFriendsWithInvitationUpdated = { friends in
            updatedFriendsWithInvitation = friends
        }
        
        viewModel.onFriendsUpdated = { friends in
            updatedFriends = friends
        }
        
        viewModel.fetchFriendsList(from: .friendsWithInvitation)
        
        // Assert: The friendsWithInvitation should be filtered correctly
        XCTAssertEqual(updatedFriendsWithInvitation.count, 1, "There should be 1 friend with invitation")
        XCTAssertEqual(updatedFriendsWithInvitation[0].name, "Friend 1", "The friend with invitation should be 'Friend 1'")
        XCTAssert(updatedFriendsWithInvitation[0].status == .sentInvitation)
        
        XCTAssertEqual(updatedFriends.count, 1, "There should be 1 friend after removing duplicates and filtering")
    }
}
