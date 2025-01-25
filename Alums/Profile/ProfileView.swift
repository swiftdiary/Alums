//
//  ProfileView.swift
//  Alums
//
//  Created by Akbar Khusanbaev on 25/01/25.
//

import SwiftUI

struct ProfileView: View {
    @State private var observable = ProfileObservable()
    @AppStorage("user_id") private var userId: Int = 0
    @AppStorage("user_role") private var userRole: String = ""
    
    var body: some View {
        List {
            Section("User") {
                Text("Full Name: ")
                Text("Email: ")
                Text("Role: ")
                Text("Group ID: ")
            }
            Section("Log Out") {
                Button("Log Out") {
                    userRole = ""
                    userId = 0
                }
                .foregroundStyle(.red)
            }
        }
    }
}
