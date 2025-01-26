//
//  SelectedRegionView.swift
//  Alums
//
//  Created by Akbar Khusanbaev on 26/01/25.
//

import SwiftUI

struct SelectedRegionView: View {
    let regionId: Int
    @Environment(LocalDataManager.self) private var localDataManager: LocalDataManager
    
    var region: LocalData.Feature? {
        localDataManager.localDataRegions?.features.first(where: { $0.id == regionId })
    }
    
    var body: some View {
        VStack {
            if let region {
                List {
                    Text("Name: \(region.properties.name)")
                    Text("Kadastr: \(region.properties.kadastr)")
                    
                    NavigationLink {
                        MapScreen(fromSelectedRegionId: regionId)
                    } label: {
                        Text("Open in Maps")
                    }

                }
            }
        }
    }
}

#Preview {
    SelectedRegionView(regionId: 1)
}
