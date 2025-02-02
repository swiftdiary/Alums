//
//  AuthObservable.swift
//  Alums
//
//  Created by Akbar Khusanbaev on 25/01/25.
//

import Foundation
import Observation

@Observable
class AuthObservable {
    var userIdInput: String = ""
    var userPasswordInput: String = ""
    
    var userData: UserData? = nil
    
    func login() async throws {
        let webSession = SwiftWebSession(url: URL(string: API.baseURLString)!)
        guard let id = Int(userIdInput) else { throw AuthenticationAuthError.invalidCredentials }
        let password = userPasswordInput
        let request = API.LoginRequest(user_id: id, password: password)
        let data = try JSONEncoder().encode(request)
        await webSession.setBody(data)
        let response = try await webSession.executeRequestDecodable(decodingType: API.LoginResponse.self, path: request.path, method: API.LoginRequest.method)
        if response.status {
            userData = UserData(userId: id, userRole: response.role ?? "worker")
        }
    }
    
    struct UserData: Hashable {
        let userId: Int
        let userRole: String
    }
    
    enum AuthenticationAuthError: Error {
        case invalidCredentials
    }
}
