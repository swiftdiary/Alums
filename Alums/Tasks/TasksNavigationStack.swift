//
//  TasksNavigationStack.swift
//  Alums
//
//  Created by Akbar Khusanbaev on 25/01/25.
//

import SwiftUI

struct TasksNavigationStack: View {
    var body: some View {
        NavigationStack {
            TasksList()
        }
    }
}

#Preview {
    TasksNavigationStack()
}
