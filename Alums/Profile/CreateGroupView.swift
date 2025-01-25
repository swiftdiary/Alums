//
//  CreateGroupView.swift
//  Alums
//
//  Created by Akbar Khusanbaev on 26/01/25.
//

import SwiftUI

struct CreateGroupView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var observable = CreateGroupObservable()
    
    var body: some View {
        List {
            TextField("Group Name", text: $observable.group_name)
            Button("Create") {
                Task {
                    try? await observable.createGroup()
                }
            }
        }
        .navigationTitle("New Group")
        .onChange(of: observable.groupCreated) { oldValue, newValue in
            if newValue {
                dismiss()
            }
        }
    }
}

#Preview {
    CreateGroupView()
}
