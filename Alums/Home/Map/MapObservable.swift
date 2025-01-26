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
    
    var selectedRegion: CurrentlyAvailableRegion = .namangan
    var selectedDistrict: CurrentlyAvailableDistrict = .chortoq
    
    var parcelsData: [API.GetParcelsResponse.Parcel] = []
    
    var parsedData: [API.GetParcelsResponse.Parcel.ParcelGeom] = []
    
    var parsedDataWithCropId: [API.GetParcelsResponse.Parcel.ParcelGeomWithCropId] = []
    
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
    
    func getParcels() async throws {
        let webSession = SwiftWebSession(url: URL(string: API.baseURLString)!)
        let request = API.GetParcelsRequest(path: "/parcels")
        let response = try await webSession.executeRequestDecodable(decodingType: API.GetParcelsResponse.self, path: request.path, method: API.GetParcelsRequest.method, queryItems: [
            .init(name: "region", value: selectedRegion.title),
            .init(name: "district", value: selectedDistrict.title)
        ])
        await MainActor.run {
            self.parcelsData = response.data
        }
    }
    
    func parseParcelsData() async throws {
        for parcel in parcelsData {
            let stringToDecode = parcel.parcel_geom
            let decodedParcelGeom: API.GetParcelsResponse.Parcel.ParcelGeom = try JSONDecoder().decode(API.GetParcelsResponse.Parcel.ParcelGeom.self, from: stringToDecode.data(using: .utf8) ?? Data())
            await MainActor.run {
                self.parsedData.append(decodedParcelGeom)
                let parcelWithCropId: API.GetParcelsResponse.Parcel.ParcelGeomWithCropId = .init(geom: decodedParcelGeom, crop_id: parcel.classified_crop_type?.crop_id ?? 4)
                self.parsedDataWithCropId.append(parcelWithCropId)
            }
        }
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
