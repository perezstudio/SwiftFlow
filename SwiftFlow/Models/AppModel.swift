//
//  AppModel.swift
//  SwiftFlow
//
//  Created by Kevin Perez on 12/28/23.
//

import Foundation
import SwiftUI
import SwiftData

@Model
final class AppProject: Identifiable, Codable {
    @Attribute(.unique) var id = UUID()
    var name: String
    var path: String
    var version: String
    var primaryColor: String
    var icon: String
    var macOS: Bool
    var iPadOS: Bool
    var iOS: Bool
    @Relationship var screens: [AppScreen] = []
    @Relationship var settings: AppSettings?

    init(name: String, path: String, version: String, primaryColor: String, icon: String, macOS: Bool, iPadOS: Bool, iOS: Bool, settings: AppSettings? = nil) {
        self.name = name
        self.path = path
        self.version = version
        self.primaryColor = primaryColor
        self.icon = icon
        self.macOS = macOS
        self.iPadOS = iPadOS
        self.iOS = iOS
        self.settings = settings
    }
    // Codable conformance
    enum CodingKeys: CodingKey {
        case id, name, path, version, primaryColor, icon, macOS, iPadOS, iOS, screens, settings
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        path = try container.decode(String.self, forKey: .path)
        version = try container.decode(String.self, forKey: .version)
        primaryColor = try container.decode(String.self, forKey: .primaryColor)
        icon = try container.decode(String.self, forKey: .icon)
        macOS = try container.decode(Bool.self, forKey: .macOS)
        iPadOS = try container.decode(Bool.self, forKey: .iPadOS)
        iOS = try container.decode(Bool.self, forKey: .iOS)
        screens = try container.decode([AppScreen].self, forKey: .screens)
        settings = try container.decodeIfPresent(AppSettings.self, forKey: .settings)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(path, forKey: .path)
        try container.encode(version, forKey: .version)
        try container.encode(primaryColor, forKey: .primaryColor)
        try container.encode(icon, forKey: .icon)
        try container.encode(macOS, forKey: .macOS)
        try container.encode(iPadOS, forKey: .iPadOS)
        try container.encode(iOS, forKey: .iOS)
        try container.encode(screens, forKey: .screens)
        try container.encodeIfPresent(settings, forKey: .settings)
    }

    static func fetchRecentProjects() -> [AppProject] {
        // Placeholder for actual SwiftData query
        let sampleSettings = AppSettings(theme: "Light", language: "English")

        return [
            AppProject(name: "SwiftFlow", path: "~/Sites/SwiftFlow", version: "1.0", primaryColor: "#FFFFFF", icon: "swift", macOS: true, iPadOS: true, iOS: true, settings: sampleSettings),
            AppProject(name: "Tasks", path: "~/Sites/Foundation Task", version: "1.1", primaryColor: "#000000", icon: "tasks", macOS: true, iPadOS: true, iOS: true, settings: sampleSettings),
            AppProject(name: "foundation-api", path: "~/Sites/Foundation Task/API", version: "1.2", primaryColor: "#FF5733", icon: "api", macOS: true, iPadOS: true, iOS: true, settings: sampleSettings)
        ]
    }
}
