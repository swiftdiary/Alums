//
//  OpenTask.swift
//  Alums
//
//  Created by Akbar Khusanbaev on 25/01/25.
//

import SwiftUI

struct OpenTask: View {
    @State private var observable: OpenTaskObservable
    let taskId: Int
    
    init(taskId: Int) {
        self.taskId = taskId
        _observable = .init(wrappedValue: .init(taskId: taskId))
    }
    
    var body: some View {
        List {
            
        }
    }
}

#Preview {
    OpenTask(taskId: 0)
}
