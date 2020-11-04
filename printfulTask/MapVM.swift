//
//  MapVM.swift
//  printfulTask
//
//  Created by Hardijs on 02/11/2020.
//

import UIKit
import MapKit

class MapVM {
    
    weak var delegate: MapVMDelegate?
    private let friendDataStream = FriendsDataStream()
    private var friendAnnotationsMap: [FriendID: FriendAnnotation] = [:]
    private var annotationPreperationQueue: OperationQueue = {
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
    
    func getDescription(for location: CLLocation, completion: @escaping (CLPlacemark?) -> Void) {
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                Logger.err("Could not grab name of the location! \(error.localizedDescription)")
            }
            completion(placemarks?.first)
        }
    }
    
    private func downloadData(for annotation: FriendAnnotation, completion: @escaping () -> Void) {
        let defaultImage = UIImage(systemName: "person.circle.fill")
        guard let url = URL(string: annotation.friend.imageUrl) else {
            annotation.friendAvatar = defaultImage
            completion()
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let data = data,
                let image = UIImage(data: data)
            else {
                //TODO: Add to retry queue
                annotation.friendAvatar = defaultImage
                Logger.err("Failed to load friends avatar! \(error?.localizedDescription ?? "No error was received")")
                return
            }
            
            annotation.friendAvatar = image
            completion()
        }.resume()
    }
    
    private func prepareFriendAnnotationsForDisplay(_ annotations: [FriendAnnotation]) {
        for annotation in annotations {
            annotationPreperationQueue.addOperation { [weak self] in
                let group = DispatchGroup()
                group.enter()
                self?.downloadData(for: annotation) {
                    group.leave()
                }
                
                let annotationLocation = CLLocation(latitude: annotation.coordinate.latitude,
                                                    longitude: annotation.coordinate.longitude)
                group.enter()
                self?.getDescription(for: annotationLocation) { description in
                    annotation.subtitle = description?.name
                    group.leave()
                }
                
                group.notify(queue: .main) {
                   self?.delegate?.annotationReadyForDisplay(annotation)
                }
            }
        }
    }
}

extension MapVM: FriendsDataListener {
    func friendLocationChanged(update: FriendUpdate) {
        if let annotation = friendAnnotationsMap[update.friendID] {
            if annotation.friend.latitude == update.latitude &&
                annotation.friend.longitude == update.longitude {
                Logger.warn("Server is sending duplicate locations for friend (\(update.friendID)), ignoring!")
                return
            }
            delegate?.annotationShouldAnimate(annotation,
                                              to: .init(latitude: update.latitude,
                                                        longitude: update.longitude))
        } else {
            Logger.warn("Make sure all friend annotations are visible before updating its location")
        }
        
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
    func annotationShouldAnimate(_ annotation: FriendAnnotation, to location: CLLocation)
}
