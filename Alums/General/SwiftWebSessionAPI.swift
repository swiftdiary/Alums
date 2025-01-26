//
//  SwiftWebSessionAPI.swift
//  Alums
//
//  Created by Akbar Khusanbaev on 24/01/25.
//

import Foundation
import Combine

public enum SwiftWebSessionError: Error {
    case invalidResponse
    case invalidStatusCode(Int)
    case noData
}

public actor SwiftWebSession {
    public var url: URL
    
    public var headers: [String: String] = [:]
    public var body: Data? = nil
    
    public let messagePublisher = PassthroughSubject<URLSessionWebSocketTask.Message, Never>()
    
    private var webSocketTask: URLSessionWebSocketTask?
    
    public init(url: URL) {
        self.url = url
    }
    
    public func setHeaders(_ headers: [String: String]) {
        self.headers = headers
    }

    public func setBody(_ body: Data) {
        self.body = body
    }
    
    public func executeRequest(path: String, method: String = "GET", queryItems: [URLQueryItem]) async throws -> (Data, URLResponse) {
        url.append(path: path)
        if queryItems.count > 0 {
            url.append(queryItems: queryItems)
        }
        var request = URLRequest(url: url)
        request.httpMethod = method
        headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        
        request.httpBody = body

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        // Debugging: Print request details
        print("Request URL: \(request.url?.absoluteString ?? "")")
        print("HTTP Method: \(request.httpMethod ?? "")")
        print("Headers: \(request.allHTTPHeaderFields ?? [:])")
        if let body = request.httpBody {
            print("Request Body: \(String(data: body, encoding: .utf8) ?? "")")
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw SwiftWebSessionError.invalidResponse
        }
        
        guard 200...299 ~= httpResponse.statusCode else {
            throw SwiftWebSessionError.invalidStatusCode(httpResponse.statusCode)
        }

        return (data, response)
    }
    
    public func executeRequestDecodable<T: Decodable>(decodingType: T.Type, path: String = "", method: String = "GET", queryItems: [URLQueryItem] = []) async throws -> T {
        let (data, _) = try await executeRequest(path: path, method: method, queryItems: queryItems)
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    // MARK: - WebSocket Methods

    public func connectWebSocket() {
        let session = URLSession(configuration: .default)
        var request = URLRequest(url: url)
        headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }

        webSocketTask = session.webSocketTask(with: request)
        webSocketTask?.resume()

        // Start receiving messages
        Task {
            await receiveWebSocketMessages()
        }
    }

    public func disconnectWebSocket() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        webSocketTask = nil
    }

    public func sendWebSocketMessage(_ message: String) async throws {
        guard let webSocketTask = webSocketTask else {
            throw WebSocketError.notConnected
        }
        let message = URLSessionWebSocketTask.Message.string(message)
        try await webSocketTask.send(message)
    }

    private func receiveWebSocketMessages() async {
        guard let webSocketTask = webSocketTask else { return }
        do {
            while true {
                let message = try await webSocketTask.receive()
                messagePublisher.send(message)
            }
        } catch {
            print("Error receiving WebSocket message: \(error)")
            disconnectWebSocket()
        }
    }

    public enum WebSocketError: Error {
        case notConnected
    }
    
    // MARK: - Multipart Form Data Upload

    public func uploadMultipartFormData(
        parameters: [String: String],
        files: [String: Data],
        fileMimeType: String = "application/octet-stream",
        boundary: String = UUID().uuidString
    ) async throws -> (Data, URLResponse) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        // Construct the multipart form data
        let bodyData = try createMultipartBody(parameters: parameters, files: files, fileMimeType: fileMimeType, boundary: boundary)
        request.httpBody = bodyData

        // Add custom headers
        headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }

        // Execute the request
        return try await URLSession.shared.data(for: request)
    }

    private func createMultipartBody(
        parameters: [String: String],
        files: [String: Data],
        fileMimeType: String,
        boundary: String
    ) throws -> Data {
        var body = Data()

        // Add parameters
        for (key, value) in parameters {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }

        // Add files
        for (fileName, fileData) in files {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: \(fileMimeType)\r\n\r\n".data(using: .utf8)!)
            body.append(fileData)
            body.append("\r\n".data(using: .utf8)!)
        }

        // End boundary
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        return body
    }
}

