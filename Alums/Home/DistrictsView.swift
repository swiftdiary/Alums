//
//  DistrictsView.swift
//  Alums
//
//  Created by Akbar Khusanbaev on 26/01/25.
//

import SwiftUI

struct DistrictsView: View {
    @Environment(LocalDataManager.self) private var localDataManager: LocalDataManager
    
    var body: some View {
        if let districts = localDataManager.localDataDistricts?.features {
            List(districts, id: \.id) { district in
                NavigationLink(value: HomeNavigationItem.district(district.id)) {
                    Text(district.properties.name)
                }
            }
        } else {
            ContentUnavailableView("No Districts", systemImage: "eye.slash")
        }
    }
}

#Preview {
    DistrictsView()
}
