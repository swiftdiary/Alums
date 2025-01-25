//
//  Map+UIViewRepresentable.swift
//  Alums
//
//  Created by Akbar Khusanbaev on 25/01/25.
//

import SwiftUI
import MapKit

struct AppMapView: UIViewRepresentable {
    @Binding var observable: MapObservable
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = observable.mapView
        
        mapView.showsCompass = false
        mapView.showsUserLocation = true
        mapView.showsUserTrackingButton = true
        mapView.showsScale = true
        mapView.isPitchEnabled = true
        mapView.pitchButtonVisibility = .visible
        mapView.preferredConfiguration = MKHybridMapConfiguration(elevationStyle: .realistic)
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
    }
    
    // Coordinator to handle MKMapView's delegate
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: AppMapView
        
        init(_ parent: AppMapView) {
            self.parent = parent
        }
    }
}
