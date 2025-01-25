//
//  AlumsApp.swift
//  Alums
//
//  Created by Akbar Khusanbaev on 24/01/25.
//

import SwiftUI

@main
struct AlumsApp: App {
    @AppStorage("user_id") private var userId: Int = 0
    @AppStorage("user_role") private var userRole: String = ""
    
    var body: some Scene {
        WindowGroup {
            if userId != 0 {
                ContentView()
            } else {
                AuthView()
            }
        }
    }
}
