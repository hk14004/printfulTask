//
//  FriendAnnotation.swift
//  printfulTask
//
//  Created by Hardijs on 02/11/2020.
//

import Foundation
import MapKit

class FriendAnnotation: NSObject, MKAnnotation {
    
    var friend: Friend
    var coordinate: CLLocationCoordinate2D
    
    init(friend: Friend) {
    self.friend = friend
    self.coordinate = CLLocationCoordinate2D(latitude: friend.latitude, longitude: friend.longitude)

    super.init()
  }
}
