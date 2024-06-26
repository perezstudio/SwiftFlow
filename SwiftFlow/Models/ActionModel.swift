//
//  ActionModel.swift
//  SwiftFlow
//
//  Created by Kevin Perez on 6/22/24.
//

import Foundation
import SwiftUI
import SwiftData

@Model
class Action: Identifiable, Codable {
    @Attribute(.unique) var id: UUID = UUID()
    var trigger: String
    var actionType: String
    var parameters: [String: String] = [:]

    init(trigger: String, actionType: String, parameters: [String: String] = [:]) {
        self.trigger = trigger
        self.actionType = actionType
        self.parameters = parameters
    }
    
    // Codable conformance
    enum CodingKeys: CodingKey {
        case id, trigger, actionType, parameters
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        trigger = try container.decode(String.self, forKey: .trigger)
        actionType = try container.decode(String.self, forKey: .actionType)
        parameters = try container.decode([String: String].self, forKey: .parameters)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container
        .encode(trigger, forKey: .trigger)
        try container.encode(actionType, forKey: .actionType)
        try container.encode(parameters, forKey: .parameters)
    }
}
