//
//  AppModel.swift
//  SwiftFlow
//
//  Created by Kevin Perez on 12/28/23.
//

import SwiftUI
import SwiftData

@Model
final class AppProject {
	var id = UUID()
	var name: String
	var path: String
	var version: String
	var primaryColor: String
	var icon: String
	var macOS: Bool
	var iPadOS: Bool
	var iOS: Bool
//	@Relationship var screens: [AppScreen]? = []
	@Relationship var settings: AppSettings?
	
	init(name: String, path: String, version: String, primaryColor: String, icon: String, macOS: Bool, iPadOS: Bool, iOS: Bool, settings: AppSettings?) {
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
	
	static func fetchRecentProjects() -> [AppProject] {
		// This function should query SwiftData to fetch recent projects
		// For now, returning static data for illustration purposes
		
		let sampleSettings = AppSettings(theme: "Light", language: "English")
		
		return [
			AppProject(name: "SwiftFlow", path: "~/Sites/SwiftFlow", version: "1.0", primaryColor: "#FFFFFF", icon: "swift", macOS: true, iPadOS: true, iOS: true, settings: sampleSettings),
			AppProject(name: "Tasks", path: "~/Sites/Foundation Task", version: "1.1", primaryColor: "#000000", icon: "tasks", macOS: true, iPadOS: true, iOS: true, settings: sampleSettings),
			AppProject(name: "foundation-api", path: "~/Sites/Foundation Task/API", version: "1.2", primaryColor: "#FF5733", icon: "api", macOS: true, iPadOS: true, iOS: true, settings: sampleSettings)
		]
	}
}
