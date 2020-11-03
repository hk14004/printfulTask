//
//  Friend.swift
//  printfulTask
//
//  Created by Hardijs on 02/11/2020.
//

import Foundation
import MapKit

typealias FriendID = String

class Friend {
    
    let id: FriendID
    let name: String
    let imageUrl: String
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    
    init(id: FriendID, name: String, imageUrl: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
        self.latitude = latitude
        self.longitude = longitude
    }
}
