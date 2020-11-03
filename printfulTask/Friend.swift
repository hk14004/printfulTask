//
//  Friend.swift
//  printfulTask
//
//  Created by Hardijs on 02/11/2020.
//

import Foundation
import MapKit

class Friend {
    
    let id: String
    let name: String
    let image: String
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    
    init(id: String, name: String, image: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        self.id = id
        self.name = name
        self.image = image
        self.latitude = latitude
        self.longitude = longitude
    }
}
