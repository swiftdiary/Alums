//
//  HomeNavigationItems.swift
//  Alums
//
//  Created by Akbar Khusanbaev on 25/01/25.
//

import SwiftUI
import Observation

@Observable
class HomeNavigationObservable {
    var path: [HomeNavigationItem] = []
    
}

enum HomeNavigationItem: Hashable, Identifiable {
    case map
    case regions
    case districts
    case region(Int)
    case district(Int)
    
    var id: HomeNavigationItem { self }
    
    @ViewBuilder
    var destination: some View {
        switch self {
        case .map: MapScreen()
        case .regions: RegionsView()
        case .districts: DistrictsView()
        case .region(let regionId): SelectedRegionView(regionId: regionId)
        case .district(let districtId): SelectedDistrictView(districtId: districtId)
        }
    }
}

