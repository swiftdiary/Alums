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
        let webSession = SwiftWebSession(url: URL(string: API.baseURLString)!)
        let request = API.GetSingleUserRequest(path: "/users/\(userId)")
        let response = try await webSession.executeRequestDecodable(decodingType: API.GetSingleUserResponse.self, path: request.path, method: API.GetSingleUserRequest.method)
        await MainActor.run {
            self.fullName = response.first_name + " " + response.last_name
            self.email = response.email
            self.role = response.role
            self.groupId = response.group_id
        }
    }
    
}
