//
//  HomeView.swift
//  Alums
//
//  Created by Akbar Khusanbaev on 25/01/25.
//

import SwiftUI

struct HomeView: View {
    
    
    var body: some View {
        List {
            NavigationLink(value: HomeNavigationItem.map) {
                Text("Open Map")
            }
        }
        .navigationTitle("Main Dashboard")
    }
}

#Preview {
    HomeNavigationStack()
}
