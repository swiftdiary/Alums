//
//  RegionsView.swift
//  Alums
//
//  Created by Akbar Khusanbaev on 26/01/25.
//

import SwiftUI

struct RegionsView: View {
    @Environment(LocalDataManager.self) private var localDataManager: LocalDataManager
    
    var body: some View {
        if let regions = localDataManager.localDataRegions?.features {
            List(regions, id: \.id) { region in
                NavigationLink(value: HomeNavigationItem.region(region.id)) {
                    Text(region.properties.name)
                }
            }
        } else {
            ContentUnavailableView("No Regions", systemImage: "eye.slash")
        }
    }
}

#Preview {
    RegionsView()
}
