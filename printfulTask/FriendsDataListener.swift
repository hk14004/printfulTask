//
//  FriendsDataListener.swift
//  printfulTask
//
//  Created by Hardijs on 02/11/2020.
//

import Foundation

protocol FriendsDataListener: class {
    func friendsListChanged(friends: [Friend])
}
