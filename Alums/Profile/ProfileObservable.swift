//
//  ProfileObservable.swift
//  Alums
//
//  Created by Akbar Khusanbaev on 25/01/25.
//

import Foundation
import Observation

@Observable
class ProfileObservable {
    var userId: Int = 0
    var fullName: String = ""
    var email: String = ""
    var role: String = ""
    var groupId: Int = 0
    
    init() {
        let id = UserDefaults.standard.value(forKey: "user_id") as? Int
        if let id {
            userId = id
        }
    }

    func getUser() async throws {
        let request = API.GetSingleUserRequest(path: "/users/\(userId)")
        
    }
    
}
