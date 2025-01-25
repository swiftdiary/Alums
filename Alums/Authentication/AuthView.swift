//
//  AuthView.swift
//  Alums
//
//  Created by Akbar Khusanbaev on 25/01/25.
//

import SwiftUI

struct AuthView: View {
    @AppStorage("user_id") private var userId: Int = 0
    @AppStorage("user_role") private var userRole: String = ""
    @State private var observable = AuthObservable()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    TextField("ID:", text: $observable.userIdInput)
                    SecureField("Password", text: $observable.userPasswordInput)
                    
                    Button("Log In") {
                        Task {
                            do {
//                                try await observable.login()
                                userRole = "admin"
                                userId = 1
                            } catch {
                                print("Error: \(error)")
                            }
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.capsule)
                }
                .textFieldStyle(.roundedBorder)
                .padding()
            }
            .navigationTitle("Authentication")
        }
        .onChange(of: observable.userData) { oldValue, newValue in
            if let userData = newValue {
                userRole = userData.userRole
                userId = userData.userId
            }
        }
    }
}

#Preview {
    AuthView()
}
