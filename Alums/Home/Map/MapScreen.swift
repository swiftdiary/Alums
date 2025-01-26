//
//  MapScreen.swift
//  Alums
//
//  Created by Akbar Khusanbaev on 25/01/25.
//

import SwiftUI
import MapKit

struct MapScreen: View {
    @Environment(LocalDataManager.self) private var localDataManager: LocalDataManager
    @State private var observable: MapObservable
    let fromSelectedDistrictId: Int
    let fromSelectedRegionId: Int
    
    init(fromSelectedDistrictId: Int = 0, fromSelectedRegionId: Int = 0) {
        self.fromSelectedDistrictId = fromSelectedDistrictId
        self.fromSelectedRegionId = fromSelectedRegionId
        self.observable = MapObservable(fromSelectedDistrictId: fromSelectedDistrictId, fromSelectedRegionId: fromSelectedRegionId)
    }
    
    var body: some View {
        VStack {
            AppMapView(polygons: observable.polygons, observable: $observable)
                .onAppear(perform: {
                    if fromSelectedRegionId > 0 {
                        guard let region = localDataManager.localDataRegions?.features.first(where: {$0.id == fromSelectedRegionId}) else { return }
                        let coordinates = region.geometry.coordinates
                        switch coordinates {
                        case .polygon(let polygonCoordinates):
                            if let polygon = observable.createPolygon(from: polygonCoordinates) {
                                observable.polygons.append(polygon)
                            }
                        case .multiPolygon(let multiPolygon):
                            for polygonCoordinates in multiPolygon {
                                if let polygon = observable.createPolygon(from: polygonCoordinates) {
                                    observable.polygons.append(polygon)
                                }
                            }
                        @unknown default:
                            break
                        }
                    }
                    if fromSelectedDistrictId > 0 {
                        guard let region = localDataManager.localDataDistricts?.features.first(where: {$0.id == fromSelectedDistrictId}) else { return }
                        let coordinates = region.geometry.coordinates
                        switch coordinates {
                        case .polygon(let polygonCoordinates):
                            if let polygon = observable.createPolygon(from: polygonCoordinates) {
                                observable.polygons.append(polygon)
                            }
                        case .multiPolygon(let multiPolygon):
                            for polygonCoordinates in multiPolygon {
                                if let polygon = observable.createPolygon(from: polygonCoordinates) {
                                    observable.polygons.append(polygon)
                                }
                            }
                        @unknown default:
                            break
                        }
                    }
                })
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        if observable.polygons.isEmpty {
                            if let region = observable.currentRegionOfUser {
                                observable.mapView.setRegion(region, animated: true)
                            }
                        }
                    }
                }
        }
        .toolbar(.hidden, for: .tabBar)
    }
}
