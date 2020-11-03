//
//  FriendAnnotation.swift
//  printfulTask
//
//  Created by Hardijs on 02/11/2020.
//

import Foundation
import MapKit

class FriendAnnotation: MKPointAnnotation {
    
    private(set) var friend: Friend
    var friendAvatar: UIImage?
    
    init(friend: Friend) {
        self.friend = friend
        super.init()
        self.coordinate = CLLocationCoordinate2D(latitude: friend.latitude, longitude: friend.longitude)
        self.title = friend.name
    }
    
    override var coordinate: CLLocationCoordinate2D {
        didSet {
            friend.longitude = coordinate.longitude
            friend.latitude = coordinate.latitude
        }
    }
}
