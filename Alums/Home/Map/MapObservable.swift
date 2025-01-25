//
//  MapObservable.swift
//  Alums
//
//  Created by Akbar Khusanbaev on 25/01/25.
//

import Observation
import MapKit
import CoreLocation
import Combine

@Observable
class MapObservable: NSObject {
    @ObservationIgnored let locationManager: CLLocationManager = CLLocationManager()
    
    var mapView: MKMapView = MKMapView()
    
    var currentLocationOfUser: CLLocationCoordinate2D? = nil
    var currentRegionOfUser: MKCoordinateRegion? = nil
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        requestLocation()
        locationManager.startUpdatingLocation()
    }
    
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
    }
}

extension MapObservable: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function)
        if let location = locations.last {
            currentLocationOfUser = location.coordinate
            self.currentRegionOfUser = MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        }
    }
    
}
