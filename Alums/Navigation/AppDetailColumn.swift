//
//  AppDetailColumn.swift
//  Alums
//
//  Created by Akbar Khusanbaev on 25/01/25.
//

import SwiftUI

struct AppDetailColumn: View {
    var screen: AppScreen?
    
    var body: some View {
        if let screen {
            screen.destination
        } else {
            ContentUnavailableView("Select some screen", systemImage: "eye.slash")
        }
    }
}

#Preview {
    AppDetailColumn(screen: .home)
}
