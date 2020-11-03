//
//  MapVM.swift
//  printfulTask
//
//  Created by Hardijs on 02/11/2020.
//

import UIKit

class MapVM {
    
    weak var delegate: MapVMDelegate?
    private let friendDataStream = FriendsDataStream()
    private var friendAnnotationsMap: [String: FriendAnnotation] = [:]
    private var downloadQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 5
        return queue
    }()
    
    init() {
        friendDataStream.delegate = self
    }
    
    func connect() {
        friendDataStream.connect()
        friendDataStream.authorize()
    }
    
    private func prepareFriendAnnotationsForDisplay(_ annotations: [FriendAnnotation]) {
        for annotation in annotations {
            downloadQueue.addOperation { [weak self] in
                guard let url = URL(string: annotation.friend.imageUrl) else {
                    annotation.friendAvatar = UIImage(systemName: "person.circle.fill")
                    self?.delegate?.annotationReadyForDisplay(annotation)
                    return
                }
                
                URLSession.shared.dataTask(with: url) { data, response, error in
                    guard
                        let data = data,
                        let image = UIImage(data: data)
                    else {
                        Logger.err("Failed to load friends avatar! \(error?.localizedDescription ?? "No error was received")")
                        return
                    }
                    
                    annotation.friendAvatar = image
                    self?.delegate?.annotationReadyForDisplay(annotation)
                }.resume()
            }
        }
    }
}

extension MapVM: FriendsDataListener {
    func friendLocationChanged(update: FriendUpdate) {
        friendAnnotationsMap["\(update.userId)"]?.updateLocation(longitude: update.longitude, latitude: update.latitude)
    }
    
    func friendsListChanged(friends: [Friend]) {
        delegate?.friendsListWillChange()
        friends.forEach { friendAnnotationsMap[$0.id] = FriendAnnotation(friend: $0) }
        prepareFriendAnnotationsForDisplay(Array(friendAnnotationsMap.values))
    }
}

protocol MapVMDelegate: class {
    func friendsListWillChange()
    func annotationReadyForDisplay(_ annotation: FriendAnnotation)
}
