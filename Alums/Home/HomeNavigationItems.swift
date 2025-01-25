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
    
    var id: HomeNavigationItem { self }
    
    @ViewBuilder
    var destination: some View {
        switch self {
        case .map: MapScreen()
        }
    }
}

