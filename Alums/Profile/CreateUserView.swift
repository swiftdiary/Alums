//
//  CreateUserView.swift
//  Alums
//
//  Created by Akbar Khusanbaev on 25/01/25.
//

import SwiftUI

struct CreateUserView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var observable = CreateUserObservable()
    
    var body: some View {
        List {
            TextField("Email", text: $observable.email)
            TextField("Password", text: $observable.password)
            TextField("First Name", text: $observable.first_name)
            TextField("Last Name", text: $observable.last_name)
            Picker("Role", selection: $observable.role) {
                Text("Admin")
                    .tag("admin")
                Text("Worker")
                    .tag("worker")
            }
            TextField("Group ID", text: $observable.group_id)
            Button("Submit") {
                Task {
                    do {
                        try await observable.createUser()
                    } catch {
                        print(error)
                    }
                }
            }
        }
        .navigationTitle("New User")
        .onChange(of: observable.newUserHasBeenCreated) { oldValue, newValue in
            if newValue {
                dismiss()
            }
        }
        
    }
}

#Preview {
    CreateUserView()
}
