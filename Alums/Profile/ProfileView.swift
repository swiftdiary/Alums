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
            
            if userRole == "admin" {
                Section("Admin Options") {
                    NavigationLink {
                        CreateUserView()
                    } label: {
                        Text("Create New User")
                    }
                    NavigationLink {
                        UsersListView()
                    } label: {
                        Text("List of Users")
                    }
                    NavigationLink {
                        CreateGroupView()
                    } label: {
                        Text("Create New Group")
                    }

                }
            }
            
            Section("User") {
                Text("Full Name: \(observable.fullName)")
                Text("Email: \(observable.email)")
                Text("Role: \(observable.role)")
                Text("Group ID: \(observable.groupId)")
            }
            Section("Log Out") {
                Button("Log Out") {
                    userRole = ""
                    userId = 0
                }
                .foregroundStyle(.red)
            }
        }
        .navigationTitle("Profile")
        .task {
            try? await observable.getUser()
        }
    }
}
