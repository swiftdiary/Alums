//
//  TasksList.swift
//  Alums
//
//  Created by Akbar Khusanbaev on 25/01/25.
//

import SwiftUI

struct TasksList: View {
    @State private var observable = TasksListObservable()
    @AppStorage("user_role") private var userRole: String = ""
    
    var body: some View {
        List {
            
            NavigationLink(value: TaskNavigationItem.open(1)) {
                Text("Hello.")
            }
        }
        .navigationTitle(userRole == "worker" ? "TODO Tasks" : "Assigned Tasks")
        .toolbar {
            if userRole == "admin" {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(value: TaskNavigationItem.create) {
                        Image(systemName: "plus.circle")
                    }
                }
            }
        }
    }
}
