//
//  LocalData.swift
//  Alums
//
//  Created by Akbar Khusanbaev on 26/01/25.
//

import Foundation

struct LocalData: Codable {
    let type: String
    let features: [Feature]
    
    struct Feature: Codable {
        let id: Int
        let type: String
        let properties: FeatureProperties
        let geometry: FeatureGeometry
        
        struct FeatureProperties: Codable {
            let fid: Int?
            let kadastr: String
            let SHAPE__Length: Double
            let SHAPE__Area: Double
            let name: String
            let cadastr_num: String
        }
        
        struct FeatureGeometry: Codable {
            let type: String
            let coordinates: Coordinates
            
            enum Coordinates: Codable {
                case polygon([[[Double]]])
                case multiPolygon([[[[Double]]]])
                
                init(from decoder: Decoder) throws {
                    let container = try decoder.singleValueContainer()
                    
                    if let polygon = try? container.decode([[[Double]]].self) {
                        self = .polygon(polygon)
                    } else if let multiPolygon = try? container.decode([[[[Double]]]].self) {
                        self = .multiPolygon(multiPolygon)
                    } else {
                        throw DecodingError.dataCorruptedError(
                            in: container,
                            debugDescription: "Invalid coordinates structure"
                        )
                    }
                }
                
                func encode(to encoder: Encoder) throws {
                    var container = encoder.singleValueContainer()
                    switch self {
                    case .polygon(let polygon):
                        try container.encode(polygon)
                    case .multiPolygon(let multiPolygon):
                        try container.encode(multiPolygon)
                    }
                }
            }
        }

    }
}

@Observable
class LocalDataManager {
    var localDataRegions: LocalData? = nil
    var localDataDistricts: LocalData? = nil
    
    var loaded: Bool = false
    
    func loadLocalData() {
        guard let url = Bundle.main.url(forResource: "regions", withExtension: "json") else {
            print("Failed to locate regions.json in bundle.")
            return
        }
        
        do {
            // Load data from the file
            let data = try Data(contentsOf: url)
            // Decode the JSON into the specified type
            let decodedData = try JSONDecoder().decode(LocalData.self, from: data)
            self.localDataRegions = decodedData
        } catch {
            print("Error decoding JSON: \(error)")
        }
        
        guard let tumanUrl = Bundle.main.url(forResource: "tuman", withExtension: "json") else {
            print("Failed to locate regions.json in bundle.")
            return
        }
        
        do {
            // Load data from the file
            let data = try Data(contentsOf: tumanUrl)
            // Decode the JSON into the specified type
            let decodedData = try JSONDecoder().decode(LocalData.self, from: data)
            self.localDataDistricts = decodedData
        } catch {
            print("Error decoding JSON: \(error)")
        }
        
        Task { @MainActor in
            self.loaded = true
        }
    }
}
