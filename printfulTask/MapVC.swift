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
    }
}
