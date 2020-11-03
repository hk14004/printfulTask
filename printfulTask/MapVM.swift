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
    private var friendsList: [Friend] = [
        Friend(id: "1", name: "Hardijs Ķirsis", image: "https://media-exp1.licdn.com/dms/image/C4E03AQEKtn17DJzVwQ/profile-displayphoto-shrink_200_200/0?e=1609977600&v=beta&t=GRfU9iLMR0qbF-ASGtW69slPI_ipvBMXhBOJqpJIWBg", latitude: 56.9495677035, longitude: 24.1064071655),
        Friend(id: "2", name: "Test 1", image: "", latitude: 57, longitude: 24.1064071655)
    ]
    
    private var friendAnnotations: [FriendAnnotation] = []
    
    private var downloadQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 5
        return queue
    }()
    
    init() {
        friendDataStream.delegate = self
    }
    
    func connect() {
        //        friendDataStream.connect()
        //        friendDataStream.authorize()
        self.friendsListChanged(friends: friendsList)
    }
    
    private func prepareFriendAnnotationsForDisplay(_ annotations: [FriendAnnotation]) {
        for annotation in annotations {
            downloadQueue.addOperation {
                guard let url = URL(string: annotation.friend.image) else { return }
                URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                    guard
                        let data = data,
                        let image = UIImage(data: data)
                    else {
                        Logger.err("Failed to load avatar, retry?")
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
    func friendsListChanged(friends: [Friend]) {
        delegate?.friendsListWillChange()
        friendAnnotations = friendsList.compactMap { FriendAnnotation(friend: $0)}
        prepareFriendAnnotationsForDisplay(friendAnnotations)
    }
}

protocol MapVMDelegate: class {
    func friendsListWillChange()
    func annotationReadyForDisplay(_ annotation: FriendAnnotation)
}
