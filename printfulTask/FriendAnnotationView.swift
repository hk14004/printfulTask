//
//  FriendAnnotationView.swift
//  printfulTask
//
//  Created by Hardijs on 03/11/2020.
//

import UIKit
import MapKit

class FriendAnnotationView: MKMarkerAnnotationView {

    static let reuseId = "FriendAnnotationView"
    
     func setup(with annotation: FriendAnnotation) {
        canShowCallout = true
        self.annotation = annotation
        let imgView = UIImageView(image: annotation.friendAvatar)
        imgView.frame = CGRect(x: imgView.frame.origin.x, y: imgView.frame.origin.y, width: 40, height: 40)
        imgView.contentMode = .scaleAspectFit
        leftCalloutAccessoryView = imgView
        clusteringIdentifier = "PinCluster"
        glyphImage = UIImage(systemName: "person.circle.fill")
        titleVisibility = .hidden
    }
}
