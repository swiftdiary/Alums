//
//  API.swift
//  Alums
//
//  Created by Akbar Khusanbaev on 25/01/25.
//

import Foundation

struct API {
    
    static let baseURLString: String = "https://alums-backend.onrender.com"
    
    struct PostAndPutResponse: APIResponsable {
        let message: String
        init(message: String) {
            self.message = message
        }
    }
    
    // POST baseURL/users
    struct CreateUserRequest: APIRequestable {
        static let method: String = "POST"
        var path: String                    // "/users"
        
        let requested_from: Int
        let data: RequestData
        
        struct RequestData: APIRequestData {
            let email: String
            let password: String
            let first_name: String
            let last_name: String
            let role: String
            let group_id: Int
            
            init(email: String, password: String, first_name: String, last_name: String, role: String, group_id: Int) {
                self.email = email
                self.password = password
                self.first_name = first_name
                self.last_name = last_name
                self.role = role
                self.group_id = group_id
            }
        }
        
        init(path: String = "/users", requested_from: Int, data: RequestData) {
            self.path = path
            self.requested_from = requested_from
            self.data = data
        }
    }
    
    // GET baseURL/users/:id
    struct GetSingleUserRequest: APIRequestable {
        static let method: String = "GET"
        var path: String                    // users/:id
        
        init(path: String) {
            self.path = path
        }
    }
    
    struct GetSingleUserResponse: APIResponsable {
        let user_id: Int
        let email: String
        let first_name: String
        let last_name: String
        let role: String
        let group_id: Int
        
        init(user_id: Int, email: String, first_name: String, last_name: String, role: String, group_id: Int) {
            self.user_id = user_id
            self.email = email
            self.first_name = first_name
            self.last_name = last_name
            self.role = role
            self.group_id = group_id
        }
    }
    
    // GET baseURL/users
    struct GetMultipleUsersRequest: APIRequestable {
        static let method: String = "GET"
        var path: String
        
        init(path: String = "/users") {
            self.path = path
        }
    }
    
    struct GetMultipleUsersResponse: APIResponsable {
        let total: Int
        let data: [GetSingleUserResponse]
    }
    
    // GET /groups/<int:group_id>
    struct GetSingleGroupRequest: APIRequestable {
        static let method: String = "GET"
        var path: String
        
        init(path: String) {
            self.path = path
        }
    }
    
    struct GetSingleGroupResponse: APIResponsable {
        let group_id: Int
        let group_name: String
    }
    
    // GET /groups
    struct GetGroupsRequest: APIRequestable {
        static let method: String = "GET"
        var path: String
        
        init(path: String = "/groups") {
            self.path = path
        }
    }
    
    struct GetGroupsResponse: APIResponsable {
        let total: Int
        let data: [GetSingleGroupResponse]
    }
    
    // POST /groups
    struct CreateGroupRequest: APIRequestable {
        static let method: String = "POST"
        var path: String
        
        var requested_from: Int
        var data: RequestData
        
        struct RequestData: APIRequestData {
            var group_name: String
            
            init(group_name: String) {
                self.group_name = group_name
            }
        }
        
        init(path: String = "/groups", requested_from: Int, data: RequestData) {
            self.path = path
            self.requested_from = requested_from
            self.data = data
        }
    }
    
    // GET /parcels
    struct GetParcelsRequest: APIRequestable {
        static let method: String = "GET"
        var path: String
        
        var region: String?
        var district: String?
        
        init(path: String = "/parcels", region: String? = nil, district: String? = nil) {
            self.path = path
            self.region = region
            self.district = district
        }
    }
    
    struct GetParcelsResponse: APIResponsable {
        let total: Int
        let data: [Parcel]
        
        struct Parcel: Codable, Sendable {
            let parcel_id: Int
            let parcel_geom: ParcelGeom
            let owner_name: String
            let mfy: String
            let district: String
            let region: String
            let kontur_number: Double
            let last_checked_on: Date?
            let farmer_crop_type: Crop?
            let classified_crop_type: Crop?
            let last_operator_crop_type: Crop?
            let last_operator: GetSingleUserResponse?
            let current_task: Int?
            let current_task_is_checked: Bool
            
            
            struct Crop: Codable, Sendable {
                let crop_id: Int
                let crop_name: String
                
                init(crop_id: Int, crop_name: String) {
                    self.crop_id = crop_id
                    self.crop_name = crop_name
                }
            }
            
            struct ParcelGeom: Codable, Sendable {
                let type: String
                let coordinates: [[[Double]]]
            }
            
            init(parcel_id: Int, parcel_geom: ParcelGeom, owner_name: String, mfy: String, district: String, region: String, kontur_number: Double, last_checked_on: Date?, farmer_crop_type: Crop?, classified_crop_type: Crop?, last_operator_crop_type: Crop?, last_operator: GetSingleUserResponse?, current_task: Int?, current_task_is_checked: Bool) {
                self.parcel_id = parcel_id
                self.parcel_geom = parcel_geom
                self.owner_name = owner_name
                self.mfy = mfy
                self.district = district
                self.region = region
                self.kontur_number = kontur_number
                self.last_checked_on = last_checked_on
                self.farmer_crop_type = farmer_crop_type
                self.classified_crop_type = classified_crop_type
                self.last_operator_crop_type = last_operator_crop_type
                self.last_operator = last_operator
                self.current_task = current_task
                self.current_task_is_checked = current_task_is_checked
            }
        }
        
        init(total: Int, data: [Parcel]) {
            self.total = total
            self.data = data
        }
    }
    
    // GET /tasks/:id
    struct GetSingleTaskRequest: APIRequestable {
        static let method: String = "GET"
        var path: String
        
        init(path: String) {
            self.path = path
        }
    }
    
    struct GetSingleTaskResponse: APIResponsable {
        let task_id: Int
        let name: String
        let description: String
        let assignment_date: Date
        let deadline_date: Date
        let status: String
        let worker: GetSingleUserResponse
        let admin: GetSingleUserResponse
        let group: GetSingleGroupResponse
        let parcels: [GetParcelsResponse.Parcel]
        
        init(task_id: Int, name: String, description: String, assignment_date: Date, deadline_date: Date, status: String, worker: GetSingleUserResponse, admin: GetSingleUserResponse, group: GetSingleGroupResponse, parcels: [GetParcelsResponse.Parcel]) {
            self.task_id = task_id
            self.name = name
            self.description = description
            self.assignment_date = assignment_date
            self.deadline_date = deadline_date
            self.status = status
            self.worker = worker
            self.admin = admin
            self.group = group
            self.parcels = parcels
        }
    }
    
    // POST /parcels/:id
    struct AddParcelRequest: APIRequestable {
        static let method: String = "POST"
        var path: String
        
        init(path: String) {
            self.path = path
        }
    }
    
    // GET /parcels/crops
    struct GetCropsRequest: APIRequestable {
        static let method: String = "GET"
        var path: String
        
        init(path: String = "/parcels/crops") {
            self.path = path
        }
    }
    
    struct GetCropsResponse: APIResponsable {
        let total: Int
        let data: [GetParcelsResponse.Parcel.Crop]
        
        init(total: Int, data: [GetParcelsResponse.Parcel.Crop]) {
            self.total = total
            self.data = data
        }
    }
    
    // POST /login
    struct LoginRequest: APIRequestable {
        static let method: String = "POST"
        var path: String
        
        let user_id: Int
        let password: String
        
        init(path: String = "/login", user_id: Int, password: String) {
            self.path = path
            self.user_id = user_id
            self.password = password
        }
    }
    
    struct LoginResponse: APIResponsable {
        let status: Bool
        let role: String?
        
        init(status: Bool, role: String) {
            self.status = status
            self.role = role
        }
    }
    
    // POST /tasks
    struct CreateTaskRequest: APIRequestable {
        static let method: String = "POST"
        var path: String
        
        var requested_from: Int
        var data: RequestData
        
        struct RequestData: APIRequestData {
            var name: String
            var description: String
            var worker_id: Int
            var group_id: Int
            var deadline_date: Date
            var parcels: [Int]
            
            init(name: String, description: String, worker_id: Int, group_id: Int, deadline_date: Date, parcels: [Int]) {
                self.name = name
                self.description = description
                self.worker_id = worker_id
                self.group_id = group_id
                self.deadline_date = deadline_date
                self.parcels = parcels
            }
        }
        
        init(path: String = "/tasks", requested_from: Int, data: RequestData) {
            self.path = path
            self.requested_from = requested_from
            self.data = data
        }
    }
    
    // GET /tasks
    struct GetTasksRequest: APIRequestable {
        static let method: String = "GET"
        var path: String
        
        var requested_from: Int
        
        init(path: String = "/tasks", requested_from: Int) {
            self.path = path
            self.requested_from = requested_from
        }
        
    }
    
    struct GetTasksResponse: APIResponsable {
        let total: Int
        var data: [TaskData]
        
        struct TaskData: Codable, Sendable {
            let task_id: Int
            let name: String
            let description: String
            let assignment_date: Date
            let deadline_date: Date
            let status: String
            let worker: GetSingleUserResponse
            let admin: GetSingleUserResponse
            let group: GetSingleGroupResponse
            let parcels: [GetParcelsResponse.Parcel]
            
            init(task_id: Int, name: String, description: String, assignment_date: Date, deadline_date: Date, status: String, worker: GetSingleUserResponse, admin: GetSingleUserResponse, group: GetSingleGroupResponse, parcels: [GetParcelsResponse.Parcel]) {
                self.task_id = task_id
                self.name = name
                self.description = description
                self.assignment_date = assignment_date
                self.deadline_date = deadline_date
                self.status = status
                self.worker = worker
                self.admin = admin
                self.group = group
                self.parcels = parcels
            }
        }
        
        init(total: Int, data: [TaskData]) {
            self.total = total
            self.data = data
        }
    }
}

protocol APIRequestable: Codable, Sendable {
    static var method: String { get }
    var path: String { get set }
}

protocol APIRequestData: Codable, Sendable {  }

protocol APIResponsable: Codable, Sendable {  }
