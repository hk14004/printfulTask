//
//  FriendAnnotation.swift
//  printfulTask
//
//  Created by Hardijs on 02/11/2020.
//

import Foundation
import MapKit

class FriendAnnotation: MKPointAnnotation {
    
    var friend: Friend
    var friendAvatar: UIImage?
    
    init(friend: Friend) {
    self.friend = friend

    super.init()
        self.coordinate = CLLocationCoordinate2D(latitude: friend.latitude, longitude: friend.longitude)
        self.title = friend.name
        self.subtitle = "Ielas nosaukums"

  }
}
