//
//  MapScreen.swift
//  Alums
//
//  Created by Akbar Khusanbaev on 25/01/25.
//

import SwiftUI
import MapKit

struct MapScreen: View {
    @State private var observable = MapObservable()
    
    var body: some View {
        VStack {
            AppMapView(observable: $observable)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        if let region = observable.currentRegionOfUser {
                            observable.mapView.setRegion(region, animated: true)
                        }
                    }
                }
        }
        .toolbar(.hidden, for: .tabBar)
    }
}

#Preview {
    MapScreen()
}
