//
//  UsersListView.swift
//  Alums
//
//  Created by Akbar Khusanbaev on 25/01/25.
//

import SwiftUI

struct UsersListView: View {
    @State private var observable = UsersListObservable()
    
    var body: some View {
        List(observable.users, id: \.user_id) { user in
            Text(user.email)
        }
        .navigationTitle("All Users")
        .task {
            try? await observable.fetchUsers()
        }
    }
}

#Preview {
    UsersListView()
}
