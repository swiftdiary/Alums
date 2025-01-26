//
//  CreateTaskObservable.swift
//  Alums
//
//  Created by Akbar Khusanbaev on 25/01/25.
//

import Foundation
import Observation

@Observable
class CreateTaskObservable {
    var requested_from: Int
    var name: String = ""
    var description: String = ""
    var worker_id: Int = 0
    var group_id: Int = 0
    var deadline_date: Date = .now
    var parcels: [Int] = []
    
    var selectedRegion: CurrentlyAvailableRegion = .namangan
    var selectedDistrict: CurrentlyAvailableDistrict = .chortoq
    
    var workers: [API.GetSingleUserResponse] = []
    var groups: [API.GetSingleGroupResponse] = []
    var parcelsData: [API.GetParcelsResponse.Parcel] = []
    
    var taskCreated: Bool = false
    
    init() {
        if let id = UserDefaults.standard.object(forKey: "user_id") as? Int {
            self.requested_from = id
        } else {
            self.requested_from = 0
        }
    }
    
    func getWorkers() async throws {
        let webSession = SwiftWebSession(url: URL(string: API.baseURLString)!)
        let request = API.GetMultipleUsersRequest()
        let response = try await webSession.executeRequestDecodable(decodingType: API.GetMultipleUsersResponse.self, path: request.path, method: API.GetMultipleUsersRequest.method)
        let workerUsers = response.data.filter({ $0.role == "worker" })
        await MainActor.run {
            self.workers = workerUsers
            self.worker_id = workers.first?.user_id ?? 0
        }
    }
    
    func getGroups() async throws {
        let webSession = SwiftWebSession(url: URL(string: API.baseURLString)!)
        let request = API.GetGroupsRequest()
        let response = try await webSession.executeRequestDecodable(decodingType: API.GetGroupsResponse.self, path: request.path, method: API.GetGroupsRequest.method)
        await MainActor.run {
            self.groups = response.data
            self.group_id = groups.first?.group_id ?? 0
        }
    }
    
    func getParcels() async throws {
        let webSession = SwiftWebSession(url: URL(string: API.baseURLString)!)
        let request = API.GetParcelsRequest(path: "/parcels")
        let response = try await webSession.executeRequestDecodable(decodingType: API.GetParcelsResponse.self, path: request.path, method: API.GetParcelsRequest.method, queryItems: [
            .init(name: "region", value: selectedRegion.title),
            .init(name: "district", value: selectedDistrict.title)
        ])
        await MainActor.run {
            self.parcelsData = response.data
        }
    }
    
    func createTask() async throws {
        let webSession = SwiftWebSession(url: URL(string: API.baseURLString)!)
        let requestData = API.CreateTaskRequest.RequestData(name: name, description: description, worker_id: worker_id, group_id: group_id, deadline_date: deadline_date.ISO8601Format(), parcels: parcels)
        let request = API.CreateTaskRequest(requested_from: requested_from, data: requestData)
        let data = try JSONEncoder().encode(request)
        await webSession.setBody(data)
        let response = try await webSession.executeRequestDecodable(decodingType: API.PostAndPutResponse.self, path: request.path, method: API.CreateTaskRequest.method)
        print("Successfully created a new Task\nMessage: \(response.message)")
        await MainActor.run {
            self.taskCreated = true
        }
    }
}

enum CurrentlyAvailableRegion: Identifiable, Hashable, CaseIterable {
    case namangan
    case navaiy
    
    var title: String {
        switch self {
        case .namangan: "Namangan"
        case .navaiy: "Navoiy"
        }
    }
    
    var regionDistricts: [CurrentlyAvailableDistrict] {
        switch self {
        case .namangan: [.chortoq, .chust, .pop]
        case .navaiy: [.navbaxor, .xatirchi, .nurota]
        }
    }
    
    var id: CurrentlyAvailableRegion { self }
}

enum CurrentlyAvailableDistrict: Identifiable, Hashable {
    
    case chortoq
    case chust
    case pop
    
    case navbaxor
    case xatirchi
    case nurota
    
    var id: CurrentlyAvailableDistrict { self }
    
    var title: String {
        switch self {
        case .chortoq: "Chortoq"
        case .chust: "Chust"
        case .navbaxor: "Navbaxor"
        case .xatirchi: "Xatirchi"
        case .nurota: "Nurota"
        case .pop: "Pop"
        }
    }
}
