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
    var polygons: [MKPolygon] = []
    
    var currentLocationOfUser: CLLocationCoordinate2D? = nil
    var currentRegionOfUser: MKCoordinateRegion? = nil
    
    var fromSelectedDistrictId: Int = 0
    var fromSelectedRegionId: Int = 0
    
    init(fromSelectedDistrictId: Int, fromSelectedRegionId: Int) {
        super.init()
        if fromSelectedRegionId > 0 || fromSelectedDistrictId > 0 {
            self.fromSelectedRegionId = fromSelectedRegionId
            self.fromSelectedDistrictId = fromSelectedDistrictId
        } else {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
            requestLocation()
            locationManager.startUpdatingLocation()
        }
    }
    
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func createPolygons(from features: [LocalData.Feature]) -> [MKPolygon] {
        var polygons: [MKPolygon] = []
        
        for feature in features {
            switch feature.geometry.coordinates {
            case .polygon(let polygonCoordinates):
                // Handle single polygon
                if let polygon = createPolygon(from: polygonCoordinates) {
                    polygons.append(polygon)
                }
            case .multiPolygon(let multiPolygonCoordinates):
                // Handle multi-polygon
                for subPolygonCoordinates in multiPolygonCoordinates {
                    if let polygon = createPolygon(from: subPolygonCoordinates) {
                        polygons.append(polygon)
                    }
                }
            }
        }
        
        return polygons
    }

    func createPolygon(from coordinates: [[[Double]]]) -> MKPolygon? {
        // Convert [[[Double]]] to [CLLocationCoordinate2D]
        guard let firstRing = coordinates.first else { return nil }
        let exterior = firstRing.map { CLLocationCoordinate2D(latitude: $0[1], longitude: $0[0]) }
        
        // Create interior rings (holes) if present
        let interiorPolygons = coordinates.dropFirst().map { ring in
            MKPolygon(coordinates: ring.map { CLLocationCoordinate2D(latitude: $0[1], longitude: $0[0]) }, count: ring.count)
        }
        
        // Create MKPolygon with exterior and interior rings
        return MKPolygon(coordinates: exterior, count: exterior.count, interiorPolygons: interiorPolygons)
    }
}

extension MapObservable: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            currentLocationOfUser = location.coordinate
            self.currentRegionOfUser = MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        }
    }
    
}
