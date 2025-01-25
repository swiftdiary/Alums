//
//  HomeNavigationStack.swift
//  Alums
//
//  Created by Akbar Khusanbaev on 25/01/25.
//

import SwiftUI

struct HomeNavigationStack: View {
    @State private var navigation = HomeNavigationObservable()
    
    var body: some View {
        NavigationStack(path: $navigation.path) {
            HomeView()
                .environment(navigation)
                .navigationDestination(for: HomeNavigationItem.self) { item in
                    item.destination
                }
        }
    }
}

#Preview {
    HomeNavigationStack()
}
