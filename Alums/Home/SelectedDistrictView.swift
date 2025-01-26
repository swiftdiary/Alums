//
//  SelectedDistrictView.swift
//  Alums
//
//  Created by Akbar Khusanbaev on 26/01/25.
//

import SwiftUI

struct SelectedDistrictView: View {
    let districtId: Int
    @Environment(LocalDataManager.self) private var localDataManager: LocalDataManager
    
    var district: LocalData.Feature? {
        localDataManager.localDataDistricts?.features.first { $0.id == districtId }
    }
    
    var body: some View {
        VStack {
            if let district {
                List {
                    Text("Name: \(district.properties.name)")
                    Text("Kadastr: \(district.properties.kadastr)")
                    
                    NavigationLink {
                        MapScreen(fromSelectedDistrictId: districtId)
                    } label: {
                        Text("Open in Maps")
                    }
                }
            }
        }
    }
}
