//
//  CreateUserObservable.swift
//  Alums
//
//  Created by Akbar Khusanbaev on 25/01/25.
//

import Foundation
import Observation

@Observable
class CreateUserObservable {
    var requestFrom: Int
    
    var email: String = ""
    var password: String = ""
    var first_name: String = ""
    var last_name: String = ""
    var role: String = "worker"
    var group_id: String = ""
    
    var newUserHasBeenCreated: Bool = false
    
    init() {
        if let id = UserDefaults.standard.value(forKey: "user_id") as? Int {
            requestFrom = id
        } else {
            requestFrom = 0
        }
    }
    
    func createUser() async throws {
        guard let groupId = Int(group_id) else {
            print("Group ID must be an integer")
            return
        }
        let webSession = SwiftWebSession(url: URL(string: API.baseURLString)!)
        let requestData = API.CreateUserRequest.RequestData(email: email, password: password, first_name: first_name, last_name: last_name, role: role, group_id: groupId)
        let request = API.CreateUserRequest(requested_from: requestFrom, data: requestData)
        let data = try JSONEncoder().encode(request)
        await webSession.setBody(data)
        let response = try await webSession.executeRequestDecodable(decodingType: API.PostAndPutResponse.self, path: request.path, method: API.CreateUserRequest.method)
        print("Successful request, returned message: \(response.message)")
        await MainActor.run {
            self.newUserHasBeenCreated = true
        }
    }
    
}
