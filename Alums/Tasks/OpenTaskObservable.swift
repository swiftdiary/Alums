//
//  OpenTaskObservable.swift
//  Alums
//
//  Created by Akbar Khusanbaev on 26/01/25.
//

import Foundation
import Observation

@Observable
class OpenTaskObservable {
    let taskId: Int
    
    init(taskId: Int) {
        self.taskId = taskId
    }
}
