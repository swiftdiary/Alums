//
//  AppScreens.swift
//  Alums
//
//  Created by Akbar Khusanbaev on 25/01/25.
//

import SwiftUI

enum AppScreen: Codable, Hashable, Identifiable, CaseIterable {
    case home
    case task
    case profile
    
    var id: AppScreen { self }
    
    @ViewBuilder
    var label: some View {
        switch self {
        case .home: Label("Home", systemImage: "house.fill")
        case .task: Label("Tasks", systemImage: "checklist")
        case .profile: Label("Profile", systemImage: "person.crop.circle.fill")
        }
    }
    
    @ViewBuilder
    var destination: some View {
        switch self {
        case .home: HomeNavigationStack()
        case .task: TasksNavigationStack()
        case .profile: ProfileNavigationStack()
        }
    }
}
