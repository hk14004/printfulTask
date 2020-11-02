//
//  ViewController.swift
//  printfulTask
//
//  Created by Hardijs on 02/11/2020.
//

import UIKit

class MapVM {
    private let friendDataStream = FriendsDataStream()
    private var friendsList: [Friend] = []
    
    init() {
        friendDataStream.delegate = self
        friendDataStream.connect()
        friendDataStream.authorize()
    }
}

extension MapVM: FriendsDataListener {
    func friendsListChanged(friends: [Friend]) {
        self.friendsList = friends
    }
}
