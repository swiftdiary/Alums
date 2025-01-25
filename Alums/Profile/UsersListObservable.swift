//
//  UsersListObservable.swift
//  Alums
//
//  Created by Akbar Khusanbaev on 25/01/25.
//

import Foundation
import Observation

@Observable
class UsersListObservable {
    var users: [API.GetSingleUserResponse] = []
    
    func fetchUsers() async throws {
        let webSession = SwiftWebSession(url: URL(string: API.baseURLString)!)
        let request = API.GetMultipleUsersRequest()
        let result = try await webSession.executeRequestDecodable(decodingType: API.GetMultipleUsersResponse.self, path: request.path, method: API.GetMultipleUsersRequest.method)
        await MainActor.run {
            self.users = result.data
        }
    }
}
