//
//  Map+UIViewRepresentable.swift
//  Alums
//
//  Created by Akbar Khusanbaev on 25/01/25.
//

import SwiftUI
import MapKit

struct AppMapView: UIViewRepresentable {
    let polygons: [MKPolygon]
    @Binding var observable: MapObservable
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = observable.mapView
        
        mapView.delegate = context.coordinator
        
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
        uiView.removeOverlays(uiView.overlays)
        uiView.addOverlays(polygons)
        if let centerCoordinate = polygons.first?.coordinate {
            uiView.setRegion(.init(center: centerCoordinate, span: .init(latitudeDelta: 0.1, longitudeDelta: 0.1)), animated: true)
        }
    }
    
    // Coordinator to handle MKMapView's delegate
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: AppMapView
        
        init(_ parent: AppMapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polygon = overlay as? MKPolygon {
                let renderer = MKPolygonRenderer(polygon: polygon)
                if polygon.subtitle == "0" {
                    renderer.fillColor = UIColor.white.withAlphaComponent(0.3)
                    renderer.strokeColor = UIColor.systemGreen
                    renderer.lineWidth = 1
                }
                if polygon.subtitle == "1" {
                    renderer.fillColor = UIColor.yellow.withAlphaComponent(0.3)
                    renderer.strokeColor = UIColor.systemYellow
                    renderer.lineWidth = 1
                }
                if polygon.subtitle == "2" {
                    renderer.fillColor = UIColor.systemBlue.withAlphaComponent(0.3)
                    renderer.strokeColor = UIColor.systemBlue
                    renderer.lineWidth = 1
                }
                if polygon.subtitle == "3" {
                    renderer.fillColor = UIColor.systemGray.withAlphaComponent(0.3)
                    renderer.strokeColor = UIColor.systemGray
                    renderer.lineWidth = 1
                }
                if polygon.subtitle == "4" {
                    renderer.fillColor = UIColor.systemRed.withAlphaComponent(0.3)
                    renderer.strokeColor = UIColor.systemRed
                    renderer.lineWidth = 1
                }
                
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}
