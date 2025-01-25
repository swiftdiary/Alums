//
//  TaskNavigationItems.swift
//  Alums
//
//  Created by Akbar Khusanbaev on 25/01/25.
//

import SwiftUI
import Observation

@Observable
class TaskNavigationObservable {
    var path: [TaskNavigationItem] = []
    
}

enum TaskNavigationItem: Hashable, Identifiable {
    case create
    case open(Int)
    
    var id: TaskNavigationItem { self }
    
    @ViewBuilder
    var destination: some View {
        switch self {
        case .create:
            CreateTask()
        case .open(let taskId):
            OpenTask(taskId: taskId)
        }
    }
}


