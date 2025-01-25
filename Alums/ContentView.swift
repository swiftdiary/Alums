//
//  ContentView.swift
//  Alums
//
//  Created by Akbar Khusanbaev on 24/01/25.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.prefersTabNavigation) private var prefersTabNavigation
    @State private var selection: AppScreen? = .home
    
    var body: some View {
        if prefersTabNavigation {
            AppTabView(selection: $selection)
        } else {
            NavigationSplitView {
                AppSidebarList(selection: $selection)
            } detail: {
                AppDetailColumn(screen: selection)
            }
        }
    }
}

#Preview {
    ContentView()
}
