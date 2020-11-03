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
    let geocoder = CLGeocoder()
    
    init(friend: Friend) {
        self.friend = friend
        
        super.init()
        self.coordinate = CLLocationCoordinate2D(latitude: friend.latitude, longitude: friend.longitude)
        self.title = friend.name
    }
    
    func updateLocation(longitude: Double, latitude: Double) {
        friend.longitude = longitude
        friend.latitude = latitude
        DispatchQueue.global().async {
            self.geocoder.reverseGeocodeLocation(
                CLLocation(latitude: latitude, longitude: longitude),
                completionHandler: { (placemarks, error) in
                    guard let placemarks = placemarks, let placeName = placemarks[0].name else {
                        Logger.err("Could not grab name of the location! \(String(describing: error?.localizedDescription))")
                        return
                    }
                    DispatchQueue.main.async {
                        UIView.animate(withDuration: 2) {
                            self.subtitle = placeName
                            self.coordinate = .init(latitude: latitude, longitude: longitude)
                        }
                    }
            })
        }
    }
}
