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
final class AppProject {
    @Attribute(.unique) var id = UUID()
    var name: String
    var version: String
    var primaryColor: String
    var icon: String
    var macOS: Bool
    var iPadOS: Bool
    var iOS: Bool
    @Relationship var files: [Files] = []
    @Relationship var screens: [AppScreen] = []
    @Relationship var settings: AppSettings?

    init(name: String, version: String, primaryColor: String, icon: String, macOS: Bool, iPadOS: Bool, iOS: Bool, files: [Files], settings: AppSettings? = nil) {
        self.name = name
        self.version = version
        self.primaryColor = primaryColor
        self.icon = icon
        self.macOS = macOS
        self.iPadOS = iPadOS
        self.iOS = iOS
        self.files = files
        self.settings = settings
    }
    // Codable conformance
    enum CodingKeys: CodingKey {
        case id, name, path, version, primaryColor, icon, macOS, iPadOS, iOS, screens, settings
    }

}
