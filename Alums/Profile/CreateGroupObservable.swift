//
//  CreateGroupObservable.swift
//  Alums
//
//  Created by Akbar Khusanbaev on 26/01/25.
//

import Foundation
import Observation

@Observable
class CreateGroupObservable {
    let requested_from: Int
    
    var group_name: String = ""
    
    var groupCreated: Bool = false
    
    init() {
        if let id = UserDefaults.standard.object(forKey: "user_id") as? Int {
            self.requested_from = id
        } else {
            self.requested_from = 0
        }
    }
    
    func createGroup() async throws {
        let webSession = SwiftWebSession(url: URL(string: API.baseURLString)!)
        let request = API.CreateGroupRequest(requested_from: requested_from, data: .init(group_name: group_name))
        let data = try JSONEncoder().encode(request)
        await webSession.setBody(data)
        let response = try await webSession.executeRequestDecodable(decodingType: API.PostAndPutResponse.self, path: request.path, method: API.CreateGroupRequest.method)
        print("Successfully created a group: \(response.message)")
        await MainActor.run {
            self.groupCreated = true
        }
    }
}
