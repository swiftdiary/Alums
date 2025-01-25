//
//  TasksNavigationStack.swift
//  Alums
//
//  Created by Akbar Khusanbaev on 25/01/25.
//

import SwiftUI

struct TasksNavigationStack: View {
    @State private var navigation = TaskNavigationObservable()
    
    var body: some View {
        NavigationStack(path: $navigation.path) {
            TasksList()
                .environment(navigation)
                .navigationDestination(for: TaskNavigationItem.self) { item in
                    item.destination
                }
        }
    }
}

#Preview {
    TasksNavigationStack()
}
