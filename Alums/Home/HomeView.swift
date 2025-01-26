//
//  HomeView.swift
//  Alums
//
//  Created by Akbar Khusanbaev on 25/01/25.
//

import SwiftUI

struct HomeView: View {
    @Environment(LocalDataManager.self) private var localData: LocalDataManager
    
    var body: some View {
        List {
            NavigationLink(value: HomeNavigationItem.map) {
                Text("Open Map")
            }
            NavigationLink(value: HomeNavigationItem.regions) {
                Text("Regions: \(localData.localDataRegions?.features.count ?? 0)")
            }
            NavigationLink(value: HomeNavigationItem.districts) {
                Text("Districts: \(localData.localDataDistricts?.features.count ?? 0)")
            }
        }
        .navigationTitle("Main Dashboard")
    }
}

#Preview {
    HomeNavigationStack()
}
