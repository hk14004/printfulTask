//
//  MapVC.swift
//  printfulTask
//
//  Created by Hardijs on 02/11/2020.
//

import UIKit
import MapKit

class MapVC: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    private let mapVM = MapVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mapVM.delegate = self
        mapView.delegate = self
        mapVM.connect()
    }
}

extension MapVC: MapVMDelegate {
    func friendsListWillChange() {
        // Make sure no old annotations are visible by removing all of them
        DispatchQueue.main.async {
            self.mapView.removeAnnotations(self.mapView.annotations)
        }
    }
    
    func annotationReadyForDisplay(_ annotation: FriendAnnotation) {
        DispatchQueue.main.async {
            self.mapView.addAnnotation(annotation)
        }
    }
}

extension MapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let friendAnnotation = annotation as? FriendAnnotation else { return nil }
        
        let identifier = FriendAnnotationView.reuseId
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? FriendAnnotationView
        if annotationView == nil {
            annotationView = FriendAnnotationView(annotation: friendAnnotation, reuseIdentifier: identifier)
        }
        annotationView?.setup(with: friendAnnotation)

        return annotationView
    }
}
